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

open Node_shim

let parse_args () =
  let program_args = ref [] in
  let append_to_args a = program_args := a :: !program_args in
  let arg_spec = [
    ("--", Arg.Rest append_to_args, "Arguments passed to program");
  ] in
  let program = ref "" in
  let set_program s = program := s in
  let usage = "Usage: node-shim program" in
  Arg.parse arg_spec set_program usage;
  if !program = "" then begin
    Arg.usage arg_spec usage;
    exit 1
  end else (Program.of_string !program, List.rev !program_args)

let get_version engines program =
  let open Package in
  let open Program in
  match program with
  | Node -> engines.node
  | Npm -> engines.npm
  | Yarn -> engines.yarn

let program_version_env_var program =
  let s = String.uppercase_ascii (Program.to_string program) in
  Printf.sprintf "NODE_SHIM_%s_VERSION" s

let get_version_from_package_json program =
  match Package.find_package_json_res () with
  | Error _ -> None
  | Ok path ->
      Logger.debug ("Found package.json: " ^ path);
      let ch = open_in path in
      let engines = Package.parse_engines_from_chan ch in
      Logger.debug ("Found engines: " ^ Package.string_of_engines engines);
      match get_version engines program with
      | None -> None
      | Some semver -> Some (Shim.find_highest_available_version program semver)

let get_executable_path program =
  let global_exec = "/usr/local/bin/" ^ Program.to_string program in
  let version_opt =
    match Sys.getenv_opt (program_version_env_var program) with
    | Some v ->
        Logger.debug ("Found version from env: " ^ v);
        Some (Version.of_string v)
    | None ->
        get_version_from_package_json program
  in
  match version_opt with
  | Some v ->
      Unix.putenv (program_version_env_var program) (Version.to_string v);
      Shim.exec_path_from_version program v
  | None -> global_exec

let _ =
  try
    let (program, program_args) = parse_args () in
    Logger.debug ("Finding executable for: " ^ Program.to_string program);
    Logger.debug ("Arguments to pass to program: " ^ String.concat ", " program_args);
    let exec = get_executable_path program in
    Logger.debug ("Found executable: " ^ exec);
    flush_all (); (* Ensure that all output is written before moving control to exec *)
    Unix.execv exec (Array.of_list (exec :: program_args))
  with e ->
    Logger.error e;
    Logger.debug (String.trim (Printexc.get_backtrace ()));
    exit 2
