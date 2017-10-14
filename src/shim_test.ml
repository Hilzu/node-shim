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

open OUnit2
open Shim
module S = Semver
module V = Version

let find_version semver version_strs =
  find_highest_compatible_version semver (List.map V.of_string version_strs)

let assert_version = assert_equal ~printer:Version.to_string
let suite = "Shim" >:::
[
  "Highest compatible version with None semver range and one correct version" >:: (
    fun _ ->
      let v = find_version (S.make S.None 1 0 0) ["1.0.0"] in
      assert_version (V.make 1 0 0) v
  );

  "Highest compatible version with Patch semver range and one correct version" >:: (
    fun _ ->
      let v = find_version (S.make S.Patch 1 0 0) ["1.0.0"] in
      assert_version (V.make 1 0 0) v
  );

  "Highest compatible version with Minor semver range and bunch of versions" >:: (
    fun _ ->
      let v = find_version (S.make S.Minor 1 0 0) ["1.0.0"; "1.6.3"; "0.1.4"; "22.52.22"; "1.4.65"] in
      assert_version (V.make 1 6 3) v
  );

  "Highest compatible version raises exception when no version found" >:: (
    fun _ ->
      assert_raises No_compatible_version (fun () ->
        find_version (S.make S.Minor 2 0 0) ["1.0.0"; "1.6.3"; "0.1.4"; "22.52.22"; "1.4.65"]
      )
  );
]
