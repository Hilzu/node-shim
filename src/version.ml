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

type t = { major : int; minor : int; patch : int; }

let make major minor patch =
  { major; minor; patch }

let to_string t =
  Printf.sprintf "%d.%d.%d" t.major t.minor t.patch

let version_regexp =
  Str.regexp "\\([0-9]+\\)\\.\\([0-9]+\\)\\.\\([0-9]+\\)"

exception Invalid_version of string
let of_string s =
  if not (Str.string_match version_regexp s 0) then raise (Invalid_version s)
  else
    let major = Str.matched_group 1 s in
    let minor = Str.matched_group 2 s in
    let patch = Str.matched_group 3 s in
    try
      make (int_of_string major) (int_of_string minor) (int_of_string patch)
    with Failure _ -> raise (Invalid_version s)
