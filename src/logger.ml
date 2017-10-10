let prefix = "node-shim:"

let print = Printf.eprintf

let info str =
  print "%s %s\n" prefix str

let enable_debug =
  try Sys.getenv "NODE_SHIM_DEBUG" = "true"
  with Not_found -> false

let debug str =
  if enable_debug then print "%s %s\n" prefix str

let error exc =
  print "%s %s\n" prefix (Printexc.to_string exc)

let _ =
  if enable_debug then Printexc.record_backtrace true
