val find_package_json : unit -> string

type engines = {node : Semver.semver; npm : Semver.semver; yarn : Semver.semver}

val string_of_engines : engines -> string

val parse_engines_from_chan : in_channel -> engines
