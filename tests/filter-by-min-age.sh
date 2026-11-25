#!/usr/bin/env bash
set -eu

project_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

binary="$tmpdir/filter-by-min-age"
input="$tmpdir/input.csv"
actual_output="$tmpdir/actual.out"
actual_errors="$tmpdir/actual.err"
expected_output="$tmpdir/expected.out"
expected_errors="$tmpdir/expected.err"

assert_file_equals() {
  expected_contents="$(<"$1")"
  actual_contents="$(<"$2")"
  if [[ "$expected_contents" != "$actual_contents" ]]; then
    printf 'Unexpected contents in %s\n' "$2" >&2
    exit 1
  fi
}

cd "$project_root"
g++ -std=c++17 -Wall -Wextra -Wpedantic -x c++ \
  src/filter-by-min-age.c -o "$binary"

printf 'Alice\n,\nA' > "$input"
: > "$expected_output"
printf 'Line 1: Age missing.\nLine 2: Age missing.\nLine 3: Age missing.\n' \
  > "$expected_errors"

if ! "$binary" 18 < "$input" > "$actual_output" 2> "$actual_errors"; then
  echo "Program failed on rows with missing ages." >&2
  exit 1
fi
assert_file_equals "$expected_output" "$actual_output"
assert_file_equals "$expected_errors" "$actual_errors"

printf 'Alice,17\nBob,18\n' > "$input"
printf 'Bob, 18\n' > "$expected_output"
: > "$expected_errors"

if ! "$binary" 18 < "$input" > "$actual_output" 2> "$actual_errors"; then
  echo "Program failed on valid input." >&2
  exit 1
fi
assert_file_equals "$expected_output" "$actual_output"
assert_file_equals "$expected_errors" "$actual_errors"

echo "filter-by-min-age tests passed"
