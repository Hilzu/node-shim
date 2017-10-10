module String = StringLabels

exception Not_a_directory of string

let root_dir = "/"

let home_dir = Unix.getenv "HOME"

let parent_dir dir =
  let sep_char = Filename.dir_sep.[0] in
  let sep_idx = String.rindex dir sep_char in
  if sep_idx = 0 then root_dir
  else String.sub dir ~pos:0 ~len:sep_idx

let is_root_dir dir =
  dir = root_dir

let rec find_file_by_traversing_up dir filename =
  let current_path = Filename.concat dir filename in
  if not (Sys.is_directory dir)
    then raise (Not_a_directory dir)
  else if Sys.file_exists current_path
    then current_path
  else if is_root_dir dir
    then raise Not_found
  else
    find_file_by_traversing_up (parent_dir dir) filename

let join = String.concat ~sep:Filename.dir_sep
