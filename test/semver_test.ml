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
open Node_shim
open Semver

let assert_semver = assert_equal ~printer:to_string
let assert_version = assert_equal ~printer:Version.to_string
let suite = "Semver" >:::
[
  "semver with no range specifier" >:: (fun _ ->
    let s = of_string "1.2.3" in
    assert_semver (make None 1 2 3) s
  );

  "semver with no range specifier" >:: (fun _ ->
    let s = of_string "0.0.1" in
    assert_semver (make None 0 0 1) s
  );

  "semver with equals range specifier" >:: (fun _ ->
    let s = of_string "=0.0.1" in
    assert_semver (make None 0 0 1) s
  );

  "semver with equals range specifier and spaces" >:: (fun _ ->
    let s = of_string " = 0.0.1 " in
    assert_semver (make None 0 0 1) s
  );

  "semver with caret range specifier" >:: (fun _ ->
    let s = of_string "^1.1.1" in
    assert_semver (make Minor 1 1 1) s
  );

  "semver with tilde range specifier" >:: (fun _ ->
    let s = of_string "~6.4.2" in
    assert_semver (make Patch 6 4 2) s
  );

  "semver with major range" >:: (fun _ ->
    let s = of_string ">= 8.5.2" in
    assert_semver (make Major 8 5 2) s
  );

  "semver with major range and patch version missing" >:: (fun _ ->
    let s = of_string ">= 8.5" in
    assert_semver (make Major 8 5 0) s
  );

  "semver with major range and minor version missing" >:: (fun _ ->
    let s = of_string ">= 8" in
    assert_semver (make Major 8 0 0) s
  );

  "exclusive max version with minor range" >:: (fun _ ->
    let s = exclusive_max_version (make Minor 1 0 0) in
    assert_version (Version.make 2 0 0) s
  );

  "exclusive max version with patch range" >:: (fun _ ->
    let s = exclusive_max_version (make Patch 1 0 0) in
    assert_version (Version.make 1 1 0) s
  );

  "exclusive max version with minor range 2" >:: (fun _ ->
    let s = exclusive_max_version (make Minor 8 9 1) in
    assert_version (Version.make 9 0 0) s
  );

  "exclusive max version with minor range 3" >:: (fun _ ->
    let s = exclusive_max_version (make Minor 9 1 0) in
    assert_version (Version.make 10 0 0) s
  );

  "exclusive max version with major range" >:: (fun _ ->
    let s = exclusive_max_version (make Major 8 10 2) in
    assert_version (Version.make max_int 0 0) s
  );

  "is_compatible with exact range" >:: (fun _ ->
    let s = make None 8 9 3 in
    let v = Version.make 8 9 0 in
    assert_bool "version should not have been compatible" (not (is_compatible s v));
    let v = Version.make 8 9 3 in
    assert_bool "version should have been compatible" (is_compatible s v)
  );

  "is_compatible with minor range" >:: (fun _ ->
    let s = make Minor 8 9 3 in
    let v = Version.make 8 10 0 in
    assert_bool "version should have been compatible" (is_compatible s v)
  );

  "is_compatible with patch range" >:: (fun _ ->
    let s = make Patch 8 9 3 in
    let v = Version.make 8 10 0 in
    assert_bool "version should not have been compatible" (not (is_compatible s v))
  );

  "is_compatible with major range" >:: (fun _ ->
    let s = make Major 8 9 3 in
    let v = Version.make 10 10 0 in
    assert_bool "version should have been compatible" (is_compatible s v);
    let v = Version.make 8 9 3 in
    assert_bool "version should have been compatible" (is_compatible s v);
    let v = Version.make 8 9 2 in
    assert_bool "version should not have been compatible" (not (is_compatible s v))
  );
]
