module J = Yojson.Basic

open Semver

type engines = {node : semver; npm : semver; yarn : semver}

let make_engines node npm yarn =
  { node; npm; yarn }

let string_of_engines e =
  let s = string_of_semver in
  Printf.sprintf "node: %s, npm: %s, yarn: %s" (s e.node) (s e.npm) (s e.yarn)

let find_package_json () =
  File.find_file_by_traversing_up (Sys.getcwd ()) "package.json"

let parse_engines_from_chan ch =
  let json = J.from_channel ch in
  (* print_endline (J.pretty_to_string json); *)
  let open J.Util in
  let engines_member = json |> member "engines" in
  let parse_semver_from m = semver_of_string (engines_member |> member m |> to_string) in
  let node = parse_semver_from "node" in
  let npm = parse_semver_from "npm" in
  let yarn = parse_semver_from "yarn" in
  make_engines node npm yarn
