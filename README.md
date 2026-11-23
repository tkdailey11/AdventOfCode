# Advent of Code

Personal solutions to [Advent of Code](https://adventofcode.com), organized as a Swift package with one target per year and a shared tools library.

## Structure

```
AdventOfCode/        executable target — main.swift runs every registered year
AOCTools/             shared library — grid/geometry helpers, graph algorithms, parsing extensions
AOC2023/, AOC2024/    one target per year
  <Year>.swift          getyear() — registers that year's days
  Days/DayNN.swift       one AOCDay per puzzle day
  Input/DayNN.txt        puzzle input for that day
scripts/new-day.sh      scaffolds a new day (and year, if needed)
scripts/fetch-input.sh  downloads your puzzle input for a day
```

Year targets are discovered automatically by `Package.swift` (it scans for folders matching `AOC####`), so adding a year never requires editing `Package.swift` by hand.

## Requirements

- Swift 6.0+ toolchain (Xcode 16+)
- macOS 15+

## Running

```sh
swift run AdventOfCode                          # every registered year/day
swift run AdventOfCode -- --year 2024           # only 2024
swift run AdventOfCode -- --year 2024 --day 2   # only 2024 day 2
swift build                                     # build only
```

`--day`/`-d` requires `--year`/`-y` (there's no cross-year "day 2 of everything" mode). Run `swift run AdventOfCode -- --help` for the full flag list.

You can also open `Package.swift` directly in Xcode for the full IDE/debugger experience — no `.xcodeproj` needed.

Each day prints its answers, how long each part took, and flags a warning if the result doesn't match the day's expected answer:

```
Day 1:
 -> Part 1: 2285373. Solved in 0.000126 seconds
 -> Part 2: 21142653. Solved in 0.000265 seconds
```

## Adding a new day

```sh
scripts/new-day.sh <year> <day>
```

- `scripts/new-day.sh 2024 4` — adds Day 4 to the existing 2024 target.
- `scripts/new-day.sh 2025 1` — creates the `AOC2025` target (folders + registration in `main.swift`) and adds Day 1 to it.

This creates `Days/DayNN.swift` from a template implementing `AOCDay`, an empty `Input/DayNN.txt` for you to paste your puzzle input into, and registers the day in that year's `getyear()`. It refuses to run if the day already exists, so it won't overwrite work.

After running it:
1. `scripts/fetch-input.sh <year> <day>` (see below) or paste your puzzle input manually into the generated `Input/DayNN.txt`.
2. Implement `parseInput`, `solvePart1`, and `solvePart2` in the generated `Days/DayNN.swift`.
3. Fill in `part1Expected`/`part2Expected` once you know the correct answers, so future runs flag regressions. Optionally fill in `part1ExpectedSample`/`part2ExpectedSample` too, which are checked when you run with `--sample`.

## Fetching your puzzle input

```sh
scripts/fetch-input.sh <year> <day> [--force]
```

Puzzle inputs are unique per account, so this needs your AoC session cookie:

1. Log into https://adventofcode.com, open your browser's dev tools, and copy the value of the `session` cookie.
2. Store it somewhere **outside the repo** — either `export AOC_SESSION=<value>` or save it to `~/.config/aoc/session`. Never commit this value; it grants full access to your AoC account.

The script refuses to overwrite a non-empty `Input/DayNN.txt` unless you pass `--force`, and identifies itself via `User-Agent` per [AoC's automation etiquette](https://adventofcode.com/about) so it doesn't look like anonymous scraping.

## AOCTools

Shared helpers available to every year/day via `import AOCTools`:

- **Geometry** — `Point2D`, `Point3D`, `HexPoint`, `Direction` (movement, rotation, neighbors, Manhattan distance)
- **Graphs** — `UnweightedGraph`/`WeightedGraph`, BFS, DFS, Dijkstra, Karger's min-cut
- **Parsing** — `String.parseGrid(_:)` (parse input directly into a `[Point2D: Tile]`), comma-separated ints, line splitting
- **Misc** — priority queue, histogram/permutation/rotation array extensions, ASCII string helpers, seeded RNG, timing utilities
