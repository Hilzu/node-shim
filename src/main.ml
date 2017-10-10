let parse_args () =
  let program_args = ref "" in
  let quote s = "\"" ^ s ^ "\"" in
  let escape_arg s = s |> String.escaped |> quote in
  let append_to_args a =
    program_args := !program_args ^ " " ^ escape_arg a
  in
  let arg_spec = [
    ("--", Arg.Rest append_to_args, "Arguments passed to program");
  ] in
  let program = ref "" in
  let set_program s = program := s in
  let usage = "Usage: node-shim program" in
  Arg.parse arg_spec set_program usage;
  (Shim.program_of_string !program, !program_args)

let get_version engines program =
  let open Package in
  let open Shim in
  match program with
  | Node -> engines.node
  | Npm -> engines.npm
  | Yarn -> engines.yarn

let get_exec program =
  let path_opt =
    try Some (Package.find_package_json ()) with Not_found -> None
  in
  match path_opt with
  | None -> "/usr/local/bin/" ^ Shim.string_of_program program
  | Some path ->
    Logger.debug ("Found package.json: " ^ path);
    let ch = open_in path in
    let engines = Package.parse_engines_from_chan ch in
    Logger.debug ("Found engines: " ^ Package.string_of_engines engines);
    let version = get_version engines program in
    let version_str = Semver.string_of_semver version in
    Shim.find_executable program version_str

let _ =
  try
    let (program, program_args) = parse_args () in
    Logger.debug ("Finding executable for: " ^ Shim.string_of_program program);
    Logger.debug ("Arguments to pass to program: " ^ program_args);
    let exec = get_exec program in
    Logger.debug ("Found executable: " ^ exec);
    let cmd = exec ^ program_args in
    let exit_code = Sys.command cmd in
    exit exit_code
  with e ->
    Logger.error e;
    Logger.debug (Printexc.get_backtrace ());
    exit 2
