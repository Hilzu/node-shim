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
open Semver

let assert_eq = assert_equal ~printer:to_string
let suite = "Semver" >:::
[
  "stable semver with no range specifier" >:: (fun _ ->
    let s = of_string "1.2.3" in
    assert_eq (make None 1 2 3) s
  );

  "unstable semver with no range specifier" >:: (fun _ ->
    let s = of_string "0.0.1" in
    assert_eq (make None 0 0 1) s
  );

  "stable semver with caret range specifier" >:: (fun _ ->
    let s = of_string "^1.1.1" in
    assert_eq (make Minor 1 1 1) s
  );

  "stable semver with tilde range specifier" >:: (fun _ ->
    let s = of_string "~6.4.2" in
    assert_eq (make Patch 6 4 2) s
  );
]
