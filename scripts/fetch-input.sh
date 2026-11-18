#!/bin/bash
#
# Download your Advent of Code puzzle input for a given year/day.
# Inputs are unique per account, so this needs your AoC session cookie.
#
# Get it: log into https://adventofcode.com, open your browser's dev tools,
# and copy the value of the "session" cookie (Application/Storage tab).
# Treat it like a password — never commit it. Store it in one of:
#   - the AOC_SESSION environment variable, or
#   - ~/.config/aoc/session (plain text file containing just the value)
#
# Usage: scripts/fetch-input.sh <year> <day> [--force]
#
# Per AoC's automation etiquette (adventofcode.com/about), this script
# identifies itself via User-Agent and refuses to re-fetch an input that's
# already saved unless you pass --force, so you don't hammer their server.

set -euo pipefail

if [[ $# -lt 2 || $# -gt 3 ]]; then
    echo "Usage: $0 <year> <day> [--force]" >&2
    exit 1
fi

year="$1"
day="$2"
force=false
if [[ "${3:-}" == "--force" ]]; then
    force=true
elif [[ -n "${3:-}" ]]; then
    echo "error: unknown argument '${3}'" >&2
    exit 1
fi

if [[ ! "$year" =~ ^[0-9]{4}$ ]]; then
    echo "error: year must be 4 digits (got '$year')" >&2
    exit 1
fi

if [[ ! "$day" =~ ^[0-9]+$ ]] || (( day < 1 || day > 25 )); then
    echo "error: day must be a number from 1-25 (got '$day')" >&2
    exit 1
fi

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root"

day_padded=$(printf "%02d" "$day")
year_dir="AOC${year}"
input_file="${year_dir}/Input/Day${day_padded}.txt"

if [[ ! -d "$year_dir" ]]; then
    echo "error: ${year_dir}/ doesn't exist yet — run scripts/new-day.sh ${year} ${day} first" >&2
    exit 1
fi

if [[ -s "$input_file" && "$force" == false ]]; then
    echo "error: ${input_file} already has content, refusing to overwrite (pass --force to replace it)" >&2
    exit 1
fi

session="${AOC_SESSION:-}"
if [[ -z "$session" && -f "$HOME/.config/aoc/session" ]]; then
    session="$(tr -d '[:space:]' < "$HOME/.config/aoc/session")"
fi

if [[ -z "$session" ]]; then
    cat >&2 <<'EOF'
error: no AoC session cookie found.

Log into https://adventofcode.com, open your browser's dev tools, and copy
the value of the "session" cookie. Then either:
  export AOC_SESSION=<cookie value>
or save it to:
  ~/.config/aoc/session
EOF
    exit 1
fi

user_agent="github.com/tkdailey11/AdventOfCode by tkdailey11@gmail.com"
url="https://adventofcode.com/${year}/day/${day}/input"

body_file="$(mktemp)"
trap 'rm -f "$body_file"' EXIT

http_code=$(curl -sS -w "%{http_code}" -o "$body_file" \
    -H "Cookie: session=${session}" \
    -H "User-Agent: ${user_agent}" \
    "$url")

if [[ "$http_code" != "200" ]]; then
    echo "error: fetch failed (HTTP ${http_code})" >&2
    head -c 300 "$body_file" >&2
    echo >&2
    exit 1
fi

mkdir -p "${year_dir}/Input"
mv "$body_file" "$input_file"

echo "Saved puzzle input to ${input_file}"
