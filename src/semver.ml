type semver = {major : int; minor : int; patch : int}

let make_semver major minor patch =
  { major; minor; patch }

let string_of_semver s =
  Printf.sprintf "%d.%d.%d" s.major s.minor s.patch

exception Invalid_semver of string

let starts_with_char s c =
  String.length s > 0 && s.[0] = c

let semver_of_string s =
  let parts =
    let str_parts = String.split_on_char '.' s in
    let [major_str; minor_str; patch_str] =
      if List.length str_parts <> 3 then raise (Invalid_semver s) else str_parts
    in
    let major_str' = if major_str.[0] = '~' || major_str.[0] = '^'
      then String.sub major_str 1 (String.length major_str - 1)
      else major_str
    in
    [major_str'; minor_str; patch_str]
  in
  let nums = List.map int_of_string parts in
  match nums with
  | [major; minor; patch] -> make_semver major minor patch
  | _ -> raise (Invalid_semver s)
