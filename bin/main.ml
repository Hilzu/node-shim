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

let commands = [
  "run";
]

let usage = {|node-shim <command> [<args>]
Valid commands: |} ^ String.concat " " commands

let () =
  let spec = [] in
  let command = ref "" in
  let parse_anon command_str =
    if !command = ""
    then
      if List.mem command_str commands
      then command := command_str
      else raise (Arg.Bad ("Unknown command: " ^ command_str))
  in
  let () = Arg.parse spec parse_anon usage in
  if !command = ""
  then begin
    Arg.usage spec usage;
    exit 1
  end else
    let base_path = Filename.dirname Sys.executable_name in
    let exec_path = Filename.concat base_path ("node-shim-" ^ !command) in
    let args = Array.sub Sys.argv 1 (Array.length Sys.argv - 1) in
    args.(0) <- exec_path;
    Unix.execv exec_path args
