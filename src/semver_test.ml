open OUnit2
open Semver

let assert_eq = assert_equal ~printer:to_string
let suite = "Semver" >:::
[
  "stable semver with no range specifier" >:: (fun _ ->
    let s = of_string "1.2.3" in
    assert_eq (make None 1 2 3) s
  );

  "unstable semver with no range specifier" >:: (fun _ ->
    let s = of_string "0.0.1" in
    assert_eq (make None 0 0 1) s
  );

  "stable semver with caret range specifier" >:: (fun _ ->
    let s = of_string "^1.1.1" in
    assert_eq (make Minor 1 1 1) s
  );

  "stable semver with tilde range specifier" >:: (fun _ ->
    let s = of_string "~6.4.2" in
    assert_eq (make Patch 6 4 2) s
  );
]
