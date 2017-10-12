open OUnit2;;

let tests = "Tests" >::: [
  Semver_test.suite;
]

let _ =
  run_test_tt_main tests
