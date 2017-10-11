exception Invalid_program of string

type t = Node | Npm | Yarn

let of_string s =
  match s with
  | "node" -> Node
  | "npm" -> Npm
  | "yarn" -> Yarn
  | _ -> raise (Invalid_program s)

let to_string p =
  match p with
  | Node -> "node"
  | Npm -> "npm"
  | Yarn -> "yarn"

let bin_path program =
  match program with
  | Node -> "bin/node"
  | Npm -> "bin/npm-cli.js"
  | Yarn -> "bin/yarn"
