type program = Node | Npm | Yarn

val program_of_string : string -> program

val string_of_program : program -> string

val find_executable : program -> string -> string
