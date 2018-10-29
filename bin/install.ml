(*
  node-shim - Utility to manage and use versions of node, npm and yarn
  Copyright (C) 2018-Present  Santeri Hiltunen

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

let usage = "Usage: node-shim-install <program> [version]\n\n" ^
  "If version is not given will install latest stable version of program.\n" ^
  "Version can also be a semver that is resolved to the latest compatible version.\n"

let () =
  let arg_spec = [] in
  let program = ref None in
  let version = ref None in
  let parse_anon a =
    let current_arg = !Arg.current in
    if current_arg = 1 then program := Some (Program.of_string a)
    else if current_arg = 2 then version := Some a
    else raise (Arg.Bad "Too many arguments given")
  in
  Arg.parse arg_spec parse_anon usage;
  match (!program, !version) with
  | None, _ ->
    Arg.usage arg_spec usage;
    exit 1
  | Some p, None -> Install.install_latest p
  | Some p, Some s -> Install.install_resolve p s
