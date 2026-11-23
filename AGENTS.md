# AGENTS.md

Instructions for AI coding agents working in this repo. See `README.md` for the human-facing overview.

## Project summary

Personal Advent of Code solutions. Swift package, one library target per year (`AOC2023`, `AOC2024`, ...), a shared `AOCTools` library, and an `AdventOfCode` executable that runs them.

## Setup / build / run

```sh
swift build                                     # compile everything
swift run AdventOfCode                          # run every registered year/day
swift run AdventOfCode -- --year 2024           # run one year
swift run AdventOfCode -- --year 2024 --day 2   # run one day
```

Requires Swift 6.0+ (Xcode 16+) and macOS 15+. No test suite exists — see "Verifying changes" below.

## Adding a day or year

Always use the scaffolding script rather than hand-creating files or editing `Package.swift`:

```sh
scripts/new-day.sh <year> <day>
```

This creates `AOC<year>/Days/DayNN.swift` from the standard template, an empty `Input/DayNN.txt`, and registers the day in that year's `getyear()`. If the year doesn't exist yet, it bootstraps the folder and registers `import AOC<year>` / `AOC<year>.getyear()` in `AdventOfCode/main.swift`. It refuses to overwrite an existing day file.

## Important: `Package.swift` is dynamic

`Package.swift` discovers year targets by scanning the repo root for folders matching `AOC####` — it does **not** list them by hand. Do not add a `.target(...)` entry for a new year manually; just create the `AOC<year>/` folder (or run `scripts/new-day.sh`). Editing the target list by hand will create a duplicate/conflicting target.

## These are learning puzzles — don't solve them for me

This repo exists so I can practice solving Advent of Code puzzles myself. The point is the struggle, not the answer.

- Never write or complete a day's `solvePart1()`/`solvePart2()` logic unless I explicitly ask for the full solution (e.g. "just solve it", "give me the implementation").
- Default mode: help with supporting infrastructure only — `AOCTools` helpers (grid parsing, BFS/DFS/Dijkstra, Point2D/Point3D math, permutations, etc.), scaffolding, build/run issues, debugging a runtime error in code I wrote, or explaining why my existing logic is wrong.
- If I ask for a hint or explanation of the puzzle, explain the approach/algorithm conceptually — don't write the code that implements it.
- If I paste my own code and ask "what's wrong", point out the bug and reasoning; don't rewrite the whole function for me.
- When in doubt about whether a request counts as "just give me the answer," ask first rather than assuming.

## Conventions

- Every day is a `public class DayNN: AOCDay` in `AOC<year>/Days/DayNN.swift`, implementing `parseInput()`, `solvePart1() -> Int`, `solvePart2() -> Int`, and setting `dayNum`/`part1Expected`/`part2Expected`.
- `part1Expected`/`part2Expected` default to `Int.min` for unsolved stubs (a sentinel no real puzzle answer will match, so an unsolved day always reports a mismatch). Note that older stubs created before this change may still default to `0`.
- Puzzle input is loaded via `AOCTools.getRawInputStringForDay(dayNum, in: Bundle.module)` — always `Bundle.module` (the SPM-generated resource bundle for that year's target), never `Bundle(for:)`.
- Before writing a new helper (grid parsing, BFS/DFS/Dijkstra, Point2D/Point3D math, permutations, etc.), check `AOCTools` first — see the "AOCTools" section of `README.md` for what already exists.

## Security — AoC session cookie

`scripts/fetch-input.sh` reads an AoC session cookie from `$AOC_SESSION` or `~/.config/aoc/session`, both **outside** this repo. Never:
- ask the user to paste their session cookie into a chat/terminal transcript you'll retain,
- hardcode a session value in any tracked file,
- or write the cookie anywhere inside the repo (including untracked scratch files you might create while debugging).

It is equivalent to a password for the user's Advent of Code account.

## Verifying changes

There's no automated test suite. After changing solver logic or shared tooling:

```sh
swift build
swift run AdventOfCode -- --year <year> --day <day>
```

Compare the printed result against `part1Expected`/`part2Expected`. Update those fields once you know the correct answers for a newly-solved day so future runs catch regressions.
