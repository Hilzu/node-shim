let shim_root = File.join [File.home_dir; ".local"; "opt"; "node-shim"]

exception Executable_not_found of string

let find_executable program version =
  let exec_path = File.join [shim_root; Program.to_string program; version; Program.bin_path program] in
  if not (Sys.file_exists exec_path) then raise (Executable_not_found exec_path)
  else exec_path
