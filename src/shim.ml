let shim_root = File.join [File.home_dir; ".local"; "opt"; "node-shim"]

exception Executable_not_found of string

exception Invalid_program of string

type program = Node | Npm | Yarn

let program_of_string s =
  match s with
  | "node" -> Node
  | "npm" -> Npm
  | "yarn" -> Yarn
  | _ -> raise (Invalid_program s)

let string_of_program p =
  match p with
  | Node -> "node"
  | Npm -> "npm"
  | Yarn -> "yarn"

let bin_path program =
  match program with
  | Node -> "bin/node"
  | Npm -> "bin/npm-cli.js"
  | Yarn -> "bin/yarn"

let find_executable program version =
  let exec_path = File.join [shim_root; string_of_program program; version; bin_path program] in
  if not (Sys.file_exists exec_path) then raise (Executable_not_found exec_path)
  else exec_path
