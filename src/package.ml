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

module J = Yojson.Basic

type engines = {node : Semver.t option; npm : Semver.t option; yarn : Semver.t option}

let make_engines node npm yarn =
  { node; npm; yarn }

let string_of_engines e =
  let s o = match o with
    | Some s -> Semver.to_string s
    | None -> "None"
  in
  Printf.sprintf "node: %s, npm: %s, yarn: %s" (s e.node) (s e.npm) (s e.yarn)

let find_package_json () =
  File.find_file_by_traversing_up (Sys.getcwd ()) "package.json"

let parse_engines_from_chan ch =
  let json = J.from_channel ch in
  let open J.Util in
  let engines_member = json |> member "engines" in
  let parse_semver_from m =
    try
      Some (Semver.of_string (engines_member |> member m |> to_string))
    with _ -> None
  in
  let node = parse_semver_from "node" in
  let npm = parse_semver_from "npm" in
  let yarn = parse_semver_from "yarn" in
  make_engines node npm yarn
