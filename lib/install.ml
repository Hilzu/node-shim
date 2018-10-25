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

let get_system_strings () =
  Lwt.wrap Sys_utils.architecture >>= fun a ->
  Sys_utils.platform () >>= fun p ->
  let a_str = match a with
  | X86 -> "x86"
  | X64 -> "x64" in
  let p_str = match p with
  | Darwin -> "darwin"
  | Linux -> "linux" in
  Lwt.return (a_str, p_str)

let resolve_addr program version =
  let v = Version.to_string version in
  get_system_strings () >>= fun (a, p) ->
  let open Program in
  let a = match program with
  | Node -> Printf.sprintf "https://nodejs.org/dist/v%s/node-v%s-%s-%s.tar.gz" v v p a
  | Npm -> Printf.sprintf "https://github.com/npm/cli/archive/v%s.tar.gz" v
  | Yarn -> Printf.sprintf "https://github.com/yarnpkg/yarn/releases/download/v%s/yarn-v%s.tar.gz" v v
  in Lwt.return a

let extracted_dir_name program version =
  let v = Version.to_string version in
  get_system_strings () >>= fun (a, p) ->
  let open Program in
  let n = match program with
  | Node -> Printf.sprintf "node-v%s-%s-%s" v p a
  | Npm -> Printf.sprintf "cli-%s" v
  | Yarn -> Printf.sprintf "yarn-v%s" v
  in Lwt.return n

let check_exists path =
  if Sys.file_exists path
  then Lwt.fail_with (Printf.sprintf "%s already exists" path)
  else Lwt.return ()

let install' program version =
  let program_dir = Shim.versions_path program in
  let version_dir = File.join [program_dir; Version.to_string version] in
  check_exists version_dir >>= fun () ->
  Unix_utils.mkdirp program_dir >>= fun () ->
  resolve_addr program version >>= fun address ->
  Lwt_io.with_temp_file (fun (temp_file_name, _) ->
    Lwt_io.printlf "Downloading from %s" address >>= fun () ->
    Unix_utils.download address temp_file_name >>= fun () ->
    Lwt_io.printl "Extracting archive..." >>= fun () ->
    Unix_utils.extract temp_file_name program_dir
  ) >>= fun () ->
  extracted_dir_name program version >>= fun extracted_dir ->
  Lwt_unix.rename (File.join [program_dir; extracted_dir]) version_dir

let resolve_latest_version program =
  let program_name = Program.to_string program in
  let version_url = Printf.sprintf "https://semver.io/%s/stable" program_name in
  Lwt_io.printlf "Resolving latest stable version of %s" program_name >>= fun () ->
  Unix_utils.get_url version_url >>= fun version ->
  Lwt.return (Version.of_string (String.trim version))

let install_latest' program =
  resolve_latest_version program >>= fun version ->
  install' program version

let install program version =
  Lwt_main.run (install' program version)

let install_latest program =
  Lwt_main.run (install_latest' program)
