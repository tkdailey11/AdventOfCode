import Darwin
import Foundation

public protocol AOCDay {
    var dayNum: Int { get }
    var part1Expected: Int { get }
    var part2Expected: Int { get }
    /// Expected answers when running with `--sample`. `Int.min` means "unknown": the check is skipped.
    var part1ExpectedSample: Int { get }
    var part2ExpectedSample: Int { get }
    
    func parseInput()
    func solveDay()

    func solvePart1() -> Int
    func solvePart2() -> Int
}

public extension AOCDay {
    var part1ExpectedSample: Int { Int.min }
    var part2ExpectedSample: Int { Int.min }

    func solveDay() {
        parseInput()
        
        print("Day \(dayNum)\(AOCConfig.useSample ? " (sample)" : ""):")

        // part 1
        var startTime = mach_absolute_time()

        let result1 = solvePart1()

        var formattedDuration = String(format: "%.6f", getSecondsFromMachTimer(duration: mach_absolute_time() - startTime))

        print(" -> Part 1: \(result1). Solved in \(formattedDuration) seconds")

        let expected1 = AOCConfig.useSample ? part1ExpectedSample : part1Expected
        if !(AOCConfig.useSample && expected1 == Int.min), expected1 != result1 {
            print(" -> ⛔️ Part 1 expected result is: \(expected1).")
        }

        // part 2
        startTime = mach_absolute_time()

        let result2 = solvePart2()

        formattedDuration = String(format: "%.6f", getSecondsFromMachTimer(duration: mach_absolute_time() - startTime))

        print(" -> Part 2: \(result2). Solved in \(formattedDuration) seconds")

        let expected2 = AOCConfig.useSample ? part2ExpectedSample : part2Expected
        if !(AOCConfig.useSample && expected2 == Int.min), expected2 != result2 {
            print(" -> ⛔️ Part 2 expected result is: \(expected2).")
        }
    }
}
