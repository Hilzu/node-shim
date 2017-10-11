val find_package_json : unit -> string

type engines = {node : Semver.t option; npm : Semver.t option; yarn : Semver.t option}

val string_of_engines : engines -> string

val parse_engines_from_chan : in_channel -> engines
