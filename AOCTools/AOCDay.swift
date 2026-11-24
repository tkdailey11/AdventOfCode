import Darwin
import Foundation

public protocol AOCDay {
    /// The answer type for each part. Inferred from `solvePartN()`'s return type; defaults to `Int`.
    associatedtype Part1Answer: Equatable = Int
    associatedtype Part2Answer: Equatable = Int

    var dayNum: Int { get }
    /// Known-correct answers; `nil` means "not known yet".
    var part1Expected: Part1Answer? { get }
    var part2Expected: Part2Answer? { get }
    /// Expected answers when running with `--sample`; `nil` means "unknown" and the check is skipped.
    var part1ExpectedSample: Part1Answer? { get }
    var part2ExpectedSample: Part2Answer? { get }
    
    func parseInput()
    func solveDay()

    func solvePart1() -> Part1Answer
    func solvePart2() -> Part2Answer
}

public extension AOCDay {
    var part1ExpectedSample: Part1Answer? { nil }
    var part2ExpectedSample: Part2Answer? { nil }

    func solveDay() {
        parseInput()
        
        let inputKind = AOCConfig.useSample ? "sample " : ""
        print("Day \(dayNum)\(AOCConfig.useSample ? " (sample)" : ""):")

        // part 1
        var startTime = mach_absolute_time()

        let result1 = solvePart1()

        var formattedDuration = String(format: "%.6f", getSecondsFromMachTimer(duration: mach_absolute_time() - startTime))

        print(" -> Part 1: \(result1). Solved in \(formattedDuration) seconds")

        let expected1 = AOCConfig.useSample ? part1ExpectedSample : part1Expected
        if let expected1 {
            if expected1 != result1 {
                print(" -> ⛔️ Part 1 expected result is: \(expected1).")
            }
        } else {
            print(" -> ⚠️ Part 1 has no expected \(inputKind)result set.")
        }

        // part 2
        startTime = mach_absolute_time()

        let result2 = solvePart2()

        formattedDuration = String(format: "%.6f", getSecondsFromMachTimer(duration: mach_absolute_time() - startTime))

        print(" -> Part 2: \(result2). Solved in \(formattedDuration) seconds")

        let expected2 = AOCConfig.useSample ? part2ExpectedSample : part2Expected
        if let expected2 {
            if expected2 != result2 {
                print(" -> ⛔️ Part 2 expected result is: \(expected2).")
            }
        } else {
            print(" -> ⚠️ Part 2 has no expected \(inputKind)result set.")
        }
    }
}
