import Darwin
import Foundation

/// A puzzle answer type. `Int` and `String` conform; `unset` is the "no answer known yet" sentinel.
public protocol AOCAnswer: Equatable {
    static var unset: Self { get }
}

extension Int: AOCAnswer {
    public static var unset: Int { Int.min }
}

extension String: AOCAnswer {
    public static var unset: String { "" }
}

public protocol AOCDay {
    /// The answer type for each part. Inferred from `solvePartN()`'s return type; defaults to `Int`.
    associatedtype Part1Answer: AOCAnswer = Int
    associatedtype Part2Answer: AOCAnswer = Int

    var dayNum: Int { get }
    var part1Expected: Part1Answer { get }
    var part2Expected: Part2Answer { get }
    /// Expected answers when running with `--sample`. `unset` means "unknown": the check is skipped.
    var part1ExpectedSample: Part1Answer { get }
    var part2ExpectedSample: Part2Answer { get }
    
    func parseInput()
    func solveDay()

    func solvePart1() -> Part1Answer
    func solvePart2() -> Part2Answer
}

public extension AOCDay {
    var part1ExpectedSample: Part1Answer { .unset }
    var part2ExpectedSample: Part2Answer { .unset }

    func solveDay() {
        parseInput()
        
        print("Day \(dayNum)\(AOCConfig.useSample ? " (sample)" : ""):")

        // part 1
        var startTime = mach_absolute_time()

        let result1 = solvePart1()

        var formattedDuration = String(format: "%.6f", getSecondsFromMachTimer(duration: mach_absolute_time() - startTime))

        print(" -> Part 1: \(result1). Solved in \(formattedDuration) seconds")

        let expected1 = AOCConfig.useSample ? part1ExpectedSample : part1Expected
        if !(AOCConfig.useSample && expected1 == .unset), expected1 != result1 {
            print(expected1 == .unset ? " -> ⛔️ Part 1 has no expected result set." : " -> ⛔️ Part 1 expected result is: \(expected1).")
        }

        // part 2
        startTime = mach_absolute_time()

        let result2 = solvePart2()

        formattedDuration = String(format: "%.6f", getSecondsFromMachTimer(duration: mach_absolute_time() - startTime))

        print(" -> Part 2: \(result2). Solved in \(formattedDuration) seconds")

        let expected2 = AOCConfig.useSample ? part2ExpectedSample : part2Expected
        if !(AOCConfig.useSample && expected2 == .unset), expected2 != result2 {
            print(expected2 == .unset ? " -> ⛔️ Part 2 has no expected result set." : " -> ⛔️ Part 2 expected result is: \(expected2).")
        }
    }
}
