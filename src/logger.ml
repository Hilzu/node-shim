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
let prefix = "node-shim:"

let print = Printf.eprintf

let info str =
  print "%s %s\n" prefix str

let enable_debug =
  try Sys.getenv "NODE_SHIM_DEBUG" = "true"
  with Not_found -> false

let debug str =
  if enable_debug then print "%s %s\n" prefix str

let error exc =
  print "%s %s\n" prefix (Printexc.to_string exc)

let _ =
  if enable_debug then Printexc.record_backtrace true
