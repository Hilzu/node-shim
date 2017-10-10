module J = Yojson.Basic

open Semver

type engines = {node : semver option; npm : semver option; yarn : semver option}

let make_engines node npm yarn =
  { node; npm; yarn }

let string_of_engines e =
  let s o = match o with
    | Some s -> string_of_semver s
    | None -> "None"
  in
  Printf.sprintf "node: %s, npm: %s, yarn: %s" (s e.node) (s e.npm) (s e.yarn)

let find_package_json () =
  File.find_file_by_traversing_up (Sys.getcwd ()) "package.json"

let parse_engines_from_chan ch =
  let json = J.from_channel ch in
  let open J.Util in
  let engines_member = json |> member "engines" in
  let parse_semver_from m =
    try
      Some (semver_of_string (engines_member |> member m |> to_string))
    with _ -> None
  in
  let node = parse_semver_from "node" in
  let npm = parse_semver_from "npm" in
  let yarn = parse_semver_from "yarn" in
  make_engines node npm yarn
