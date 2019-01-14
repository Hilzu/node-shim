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
let shim_root =
  try Sys.getenv "NODE_SHIM_ROOT" with Not_found ->
    File.join [File.home_dir; ".local"; "opt"; "node-shim"]

exception Executable_not_found of string

exception No_compatible_version_found

let find_highest_compatible_version semver versions =
  let is_compatible = Semver.is_compatible semver in
  let compatible_versions = List.filter is_compatible versions in
  Logger.debug
    ( "Found compatible versions: "
    ^ String.concat ", " (List.map Version.to_string compatible_versions) );
  match compatible_versions with
  | [] -> raise No_compatible_version_found
  | [v] -> v
  | versions ->
      let descending_compare x y = ~-(compare x y) in
      List.hd (List.sort descending_compare versions)

let versions_path program = File.join [shim_root; Program.to_string program]

let exec_path_from_version program version =
  let exec_path =
    File.join
      [ versions_path program
      ; Version.to_string version
      ; Program.bin_path program ]
  in
  if not (Sys.file_exists exec_path) then
    raise (Executable_not_found exec_path)
  else exec_path

let find_highest_available_version program semver =
  let files = Array.to_list (Sys.readdir (versions_path program)) in
  let matches_version_pattern s =
    Str.string_match Version.version_regexp s 0
  in
  let all_version_strs = List.filter matches_version_pattern files in
  let all_versions = List.map Version.of_string all_version_strs in
  Logger.debug
    ("Found available versions: " ^ String.concat ", " all_version_strs);
  find_highest_compatible_version semver all_versions
