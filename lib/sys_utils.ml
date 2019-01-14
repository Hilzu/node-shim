(*
  node-shim - Utility to manage and use versions of node, npm and yarn
  Copyright (C) 2018-Present  Santeri Hiltunen

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

open Lwt.Infix

type platform = Darwin | Linux

let platform' () =
  Lwt_process.pread ("", [|"uname"; "-s"|])
  >>= fun s ->
  match String.trim s with
  | "Darwin" -> Lwt.return Darwin
  | "Linux" -> Lwt.return Linux
  | p -> Lwt.fail_with ("Unsupported platform: " ^ p)

let platform = Fun_utils.memoize_const platform'

type architecture = X86 | X64

let architecture () =
  match Sys.word_size with
  | 32 -> X86
  | 64 -> X64
  | i -> raise (Failure (Printf.sprintf "Unsupported word size: %d" i))
