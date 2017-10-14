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

type range = Minor | Patch | None

type t = {major : int; minor : int; patch : int; range : range }

let make range major minor patch =
  { major; minor; patch; range }

let string_of_range r = match r with
  | Minor -> "^"
  | Patch -> "~"
  | None -> ""

let range_of_string s = match s with
  | "^" -> Minor
  | "~" -> Patch
  | "" -> None
  | _ -> raise (invalid_arg s)

let to_version_string s =
  Printf.sprintf "%d.%d.%d" s.major s.minor s.patch

let to_string s =
  Printf.sprintf "%s%s" (string_of_range s.range) (to_version_string s)

exception Invalid_semver of string

let semver_regexp =
  let range = "\\([~^]\\)?" in
  let num = "\\([0-9]+\\)" in
  let dot = "\\." in
  Str.regexp (range ^ num ^ dot ^ num ^ dot ^ num)

let of_string s =
  if not (Str.string_match semver_regexp s 0) then raise (Invalid_semver s)
  else
    let r = try Str.matched_group 1 s with Not_found -> "" in
    let major = int_of_string (Str.matched_group 2 s) in
    let minor = int_of_string (Str.matched_group 3 s) in
    let patch = int_of_string (Str.matched_group 4 s) in
    make (range_of_string r) major minor patch
