(*
  node-shim - Utility to manage and use versions of node, npm and yarn
  Copyright (C) 2017-Present  Santeri Hiltunen

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.
*)

let parse_args () =
  let program_args = ref [] in
  let append_to_args a =
    program_args := a :: !program_args
  in
  let arg_spec = [
    ("--", Arg.Rest append_to_args, "Arguments passed to program");
  ] in
  let program = ref "" in
  let set_program s = program := s in
  let usage = "Usage: node-shim program" in
  Arg.parse arg_spec set_program usage;
  (Program.of_string !program, List.rev !program_args)

let get_version engines program =
  let open Package in
  let open Program in
  match program with
  | Node -> engines.node
  | Npm -> engines.npm
  | Yarn -> engines.yarn

let get_exec program =
  let global_exec = "/usr/local/bin/" ^ Program.to_string program in
  let path_opt =
    try Some (Package.find_package_json ()) with Not_found -> None
  in
  match path_opt with
  | None -> global_exec
  | Some path ->
    Logger.debug ("Found package.json: " ^ path);
    let ch = open_in path in
    let engines = Package.parse_engines_from_chan ch in
    Logger.debug ("Found engines: " ^ Package.string_of_engines engines);
    match get_version engines program with
    | None -> global_exec
    | Some version ->
      let version_str = Semver.to_version_string version in
      Shim.find_executable program version_str

let _ =
  try
    let (program, program_args) = parse_args () in
    Logger.debug ("Finding executable for: " ^ Program.to_string program);
    Logger.debug ("Arguments to pass to program: " ^ String.concat ", " program_args);
    let exec = get_exec program in
    Logger.debug ("Found executable: " ^ exec);
    flush_all (); (* Ensure that all output is written before moving control to exec *)
    Unix.execv exec (Array.of_list (exec :: program_args))
  with e ->
    Logger.error e;
    Logger.debug (String.trim (Printexc.get_backtrace ()));
    exit 2
