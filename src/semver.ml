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

type t = {version : Version.t; range : range }

let make range major minor patch =
  { range; version = Version.make major minor patch }

let string_of_range r = match r with
  | Minor -> "^"
  | Patch -> "~"
  | None -> ""

let range_of_string s = match s with
  | "^" -> Minor
  | "~" -> Patch
  | "" -> None
  | _ -> raise (invalid_arg s)

let to_version s = s.version

let to_string s =
  Printf.sprintf "%s%s" (string_of_range s.range) (Version.to_string s.version)

exception Invalid_semver of string

let semver_regexp =
  let range = "\\([~^]\\)?" in
  let num = "\\([0-9]+\\)" in
  let dot = "\\." in
  Str.regexp (range ^ num ^ dot ^ num ^ dot ^ num)

let of_string s =
  if not (Str.string_match semver_regexp s 0) then raise (Invalid_semver s) else
  let r = try Str.matched_group 1 s with Not_found -> "" in
  let major = int_of_string (Str.matched_group 2 s) in
  let minor = int_of_string (Str.matched_group 3 s) in
  let patch = int_of_string (Str.matched_group 4 s) in
  make (range_of_string r) major minor patch

let min_version t = t.version

let exclusive_max_version t =
  let v = t.version in
  let open Version in
  match t.range with
  | Minor -> { major = v.major + 1; minor = 0; patch = 0 }
  | Patch -> { v with minor = v.minor + 1; patch = 0 }
  | None -> { v with patch = v.patch + 1 }

let is_compatible t v = v >= min_version t && v < exclusive_max_version t
