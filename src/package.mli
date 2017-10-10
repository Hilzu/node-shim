val find_package_json : unit -> string

type engines = {node : Semver.semver option; npm : Semver.semver option; yarn : Semver.semver option}

val string_of_engines : engines -> string

val parse_engines_from_chan : in_channel -> engines
