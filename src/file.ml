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

module String = StringLabels

exception Not_a_directory of string

let root_dir = "/"

let home_dir = Unix.getenv "HOME"

let parent_dir dir =
  let sep_char = Filename.dir_sep.[0] in
  let sep_idx = String.rindex dir sep_char in
  if sep_idx = 0 then root_dir else
  String.sub dir ~pos:0 ~len:sep_idx

let is_root_dir dir = dir = root_dir

let rec find_file_by_traversing_up dir filename =
  let current_path = Filename.concat dir filename in
  if not (Sys.is_directory dir) then raise (Not_a_directory dir) else
  if Sys.file_exists current_path then current_path else
  if is_root_dir dir then raise Not_found else
  find_file_by_traversing_up (parent_dir dir) filename

let join = String.concat ~sep:Filename.dir_sep
