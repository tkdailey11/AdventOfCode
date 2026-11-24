#!/bin/bash
#
# Scaffold a new Advent of Code day, bootstrapping the year if needed.
#
# Usage: scripts/new-day.sh <year> <day>
#   e.g. scripts/new-day.sh 2024 4
#   e.g. scripts/new-day.sh 2025 1   (creates the AOC2025 target too)

set -euo pipefail

if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <year> <day>" >&2
    exit 1
fi

year="$1"
day="$2"

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
year_file="${year_dir}/${year_dir}.swift"
day_file="${year_dir}/Days/Day${day_padded}.swift"
input_file="${year_dir}/Input/Day${day_padded}.txt"
sample_file="${year_dir}/Input/Day${day_padded}Sample.txt"

# insert_after <exact line> <text> <file> — insert a line of text after the first line equal to <exact line>
insert_after() {
    local target="$1" text="$2" file="$3"
    awk -v target="$target" -v txt="$text" '{ print; if (!done && $0 == target) { print txt; done=1 } }' "$file" > "${file}.tmp"
    mv "${file}.tmp" "$file"
}

# insert_before <exact line> <text> <file> — insert a line of text before the first line equal to <exact line>
insert_before() {
    local target="$1" text="$2" file="$3"
    awk -v target="$target" -v txt="$text" '{ if (!done && $0 == target) { print txt; done=1 }; print }' "$file" > "${file}.tmp"
    mv "${file}.tmp" "$file"
}

if [[ -d "$year_dir" ]]; then
    echo "Year ${year}: using existing ${year_dir}/"
else
    echo "Year ${year}: bootstrapping ${year_dir}/ (new Package.swift target)"
    mkdir -p "${year_dir}/Days" "${year_dir}/Input"

    cat > "$year_file" <<EOF
import Foundation
import AOCTools

public func getyear() -> AOCYear {
    AOCYear(yearNum: ${year}, days: [
    ])
}
EOF

    insert_after "import AOCTools" "import AOC${year}" AdventOfCode/main.swift
    insert_after "let allYears = [" "    AOC${year}.getyear()," AdventOfCode/main.swift
fi

if [[ -f "$day_file" ]]; then
    echo "error: ${day_file} already exists, aborting" >&2
    exit 1
fi

cat > "$day_file" <<EOF
import Foundation
import AOCTools

public class Day${day_padded}: AOCDay {
    public var dayNum: Int = ${day}
    public var part1Expected: Int? = nil
    public var part2Expected: Int? = nil
    public var part1ExpectedSample: Int? = nil
    public var part2ExpectedSample: Int? = nil

    public func parseInput() {
        let contents = AOCTools.getRawInputStringForDay(dayNum, in: Bundle.module)
    }

    public func solvePart1() -> Int {
        0
    }

    public func solvePart2() -> Int {
        0
    }
}
EOF

touch "$input_file" "$sample_file"

insert_before "    ])" "        Day${day_padded}()," "$year_file"

echo "Created:"
echo "  ${day_file}"
echo "  ${input_file} (empty — paste your puzzle input here)"
echo "  ${sample_file} (empty — paste the puzzle's example input here)"
echo
echo "Registered Day${day_padded} in ${year_file}"
echo
echo "Next steps:"
echo "  1. scripts/fetch-input.sh ${year} ${day}   (or paste your puzzle input into ${input_file} manually)"
echo "  2. Fill in parseInput/solvePart1/solvePart2 in ${day_file}"
echo "  3. Set part1Expected/part2Expected (and the *Sample variants) once you know the right answers"
echo "  4. swift run AdventOfCode"
