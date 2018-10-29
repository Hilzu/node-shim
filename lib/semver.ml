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

type range = Major | Minor | Patch | Exact

type t = {version : Version.t; range : range }

let make range major minor patch =
  { range; version = Version.make major minor patch }

let string_of_range r = match r with
  | Major -> ">="
  | Minor -> "^"
  | Patch -> "~"
  | Exact -> "="

let range_of_string s = match s with
  | ">=" -> Major
  | "^" -> Minor
  | "~" -> Patch
  | "" | "=" -> Exact
  | _ -> raise (invalid_arg s)

let to_version s = s.version

let to_string s =
  Printf.sprintf "%s%s" (string_of_range s.range) (Version.to_string s.version)

exception Invalid_semver of string

let semver_regexp =
  let range = "\\([~^=<>*]*\\)?" in
  let num = "\\([0-9x]+\\)?" in
  let dot = "\\.?" in
  Str.regexp ("^" ^ range ^ num ^ dot ^ num ^ dot ^ num ^ "$")

let whitespace_regexp = Str.regexp "[ \t\r\n]+"

let of_string s =
  let s = Str.global_replace whitespace_regexp "" s in
  if not (Str.string_match semver_regexp s 0) then raise (Invalid_semver s) else
  if s = "" || s = "*" then (make Major 0 0 0) else
  let range = ref
    (try range_of_string (Str.matched_group 1 s) with Not_found -> Exact)
  in
  let parse_part i r =
    try
      let group = Str.matched_group i s in
      if group = "x" then raise Not_found else
      int_of_string group
    with Not_found ->
      if !range = Exact then range := r;
      0
  in
  let major = parse_part 2 Major in
  let minor = parse_part 3 Minor in
  let patch = parse_part 4 Patch in
  if major = 0 then range := (
    match !range with
    | Major -> Minor
    | Minor -> Patch
    | Patch | Exact -> Exact
  );
  make !range major minor patch

let min_version t = t.version

let exclusive_max_version t =
  let v = t.version in
  let open Version in
  match t.range with
  | Major -> { major = max_int; minor = 0; patch = 0 }
  | Minor -> { major = v.major + 1; minor = 0; patch = 0 }
  | Patch -> { v with minor = v.minor + 1; patch = 0 }
  | Exact -> { v with patch = v.patch + 1 }

let is_compatible t v = v >= min_version t && v < exclusive_max_version t
