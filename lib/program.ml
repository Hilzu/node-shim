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

exception Invalid_program of string

type t = Node | Npm | Yarn

let of_string s =
  match s with
  | "node" -> Node
  | "npm" -> Npm
  | "yarn" -> Yarn
  | _ -> raise (Invalid_program s)

let to_string p = match p with Node -> "node" | Npm -> "npm" | Yarn -> "yarn"

let bin_path program =
  match program with
  | Node -> "bin/node"
  | Npm -> "bin/npm-cli.js"
  | Yarn -> "bin/yarn"
