type range =  Minor | Patch | None

type t

val make : range -> int -> int -> int -> t

val to_version_string : t -> string

val to_string : t -> string

val of_string : string -> t
