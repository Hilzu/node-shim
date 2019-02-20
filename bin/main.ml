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

let commands = ["run"; "install"]

let usage =
  {|Usage: node-shim <command> [<args>]
Valid commands: |}
  ^ String.concat " " commands

let help_doc = "Display this list of options"

let print_version () =
  print_endline "%%VERSION%%";
  exit 0

let () =
  let command = ref "" in
  let rec help_spec () =
    if !command = "" then
      raise (Arg.Help (Arg.usage_string (make_spec ()) usage))
  and make_spec () =
    [ ("-help", Arg.Unit help_spec, help_doc)
    ; ("--help", Arg.Unit help_spec, help_doc)
    ; ("--version", Arg.Unit print_version, "Print node-shim version")]
  in
  let parse_anon command_str =
    if !command = "" then
      if List.mem command_str commands then command := command_str
      else raise (Arg.Bad ("Unknown command: " ^ command_str))
  in
  Arg.parse (make_spec ()) parse_anon usage;
  if !command = "" then (
    Arg.usage (make_spec ()) usage;
    exit 1 )
  else
    let base_path = Filename.dirname Sys.executable_name in
    let exec_path = Filename.concat base_path ("node-shim-" ^ !command) in
    let args = Array.sub Sys.argv 1 (Array.length Sys.argv - 1) in
    args.(0) <- exec_path; Unix.execv exec_path args
