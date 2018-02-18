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

let platform () =
  Lwt_process.pread ("", [|"uname"; "-s"|]) >>= fun s ->
  match String.trim s with
  | "Darwin" -> Lwt.return "darwin"
  | "Linux" -> Lwt.return "linux"
  | p -> Lwt.fail_with ("Unsupported platform: " ^ p)

let architecture () =
  match Sys.word_size with
  | 32 -> "x86"
  | 64 -> "x64"
  | i -> raise (Failure (Printf.sprintf "Unsupported word size: %d" i))

let resolve_addr program version =
  let v = Version.to_string version in
  Lwt.wrap architecture >>= fun a ->
  platform () >>= fun p ->
  let open Program in
  let a = match program with
  | Node -> Printf.sprintf "https://nodejs.org/dist/v%s/node-v%s-%s-%s.tar.gz" v v p a
  | Npm -> Printf.sprintf "https://github.com/npm/npm/archive/v%s.tar.gz" v
  | Yarn -> Printf.sprintf "https://github.com/yarnpkg/yarn/releases/download/v%s/yarn-v%s.tar.gz" v v
  in Lwt.return a

let extracted_dir_name program version =
  let v = Version.to_string version in
  Lwt.wrap architecture >>= fun a ->
  platform () >>= fun p ->
  let open Program in
  let n = match program with
  | Node -> Printf.sprintf "node-v%s-%s-%s" v p a
  | Npm -> Printf.sprintf "npm-%s" v
  | Yarn -> Printf.sprintf "yarn-v%s" v
  in Lwt.return n

let string_of_process_status = function
  | Unix.WEXITED n -> Printf.sprintf "exit code %d" n
  | Unix.WSIGNALED n -> Printf.sprintf "killed by signal %d" n
  | Unix.WSTOPPED n -> Printf.sprintf "stopped by signal %d" n

let exec args =
  Lwt_process.exec ("", args) >>= function
  | Unix.WEXITED 0 -> Lwt.return ()
  | ps ->
    Lwt.fail_with (
      Printf.sprintf
        "Failed to execute command '%s'. Failed with: %s"
        args.(0) (string_of_process_status ps))

let mkdirp path = exec [|"mkdir"; "-p"; path|]

let download url target = exec [|"wget"; "--quiet"; "-O"; target; url|]

let extract archive target_dir = exec [|"tar"; "-xzf"; archive; "-C"; target_dir|]

let check_exists path =
  if Sys.file_exists path
  then Lwt.fail_with (Printf.sprintf "%s already exists" path)
  else Lwt.return ()

let install' program version =
  let program_dir = Shim.versions_path program in
  let version_dir = File.join [program_dir; Version.to_string version] in
  check_exists version_dir >>= fun () ->
  mkdirp program_dir >>= fun () ->
  resolve_addr program version >>= fun address ->
  Lwt_io.with_temp_file (fun (temp_file_name, temp_ch) ->
    Lwt_io.printlf "Downloading from %s" address >>= fun () ->
    download address temp_file_name >>= fun () ->
    Lwt_io.printl "Extracting archive..." >>= fun () ->
    extract temp_file_name program_dir
  ) >>= fun () ->
  extracted_dir_name program version >>= fun extracted_dir ->
  Lwt_unix.rename (File.join [program_dir; extracted_dir]) version_dir

let install program version =
  Lwt_main.run (install' program version);
