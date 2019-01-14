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

let string_of_process_status = function
  | Unix.WEXITED n -> Printf.sprintf "exit code %d" n
  | Unix.WSIGNALED n -> Printf.sprintf "killed by signal %d" n
  | Unix.WSTOPPED n -> Printf.sprintf "stopped by signal %d" n

let exec args =
  Lwt_process.exec ("", args)
  >>= function
  | Unix.WEXITED 0 -> Lwt.return ()
  | ps ->
      Lwt.fail_with
        (Printf.sprintf "Failed to execute command '%s'. Failed with: %s"
           args.(0)
           (string_of_process_status ps))

let mkdirp path = exec [|"mkdir"; "-p"; path|]

let download url target = exec [|"wget"; "--quiet"; "-O"; target; url|]

let get_url url = Lwt_process.pread ("", [|"wget"; "-qO-"; url|])

let extract archive target_dir =
  exec [|"tar"; "-xzf"; archive; "-C"; target_dir|]
