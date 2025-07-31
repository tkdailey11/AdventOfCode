import Darwin
import Foundation

public protocol AOCDay {
    var dayNum: Int { get }
    var part1Expected: Int { get }
    var part2Expected: Int { get }
    
    func parseInput(rawString: String)
    func solveDay()

    func solvePart1() -> Int
    func solvePart2() -> Int
}

public extension AOCDay {
    func solveDay() {
        print("Day \(dayNum):")

        // part 1
        var startTime = mach_absolute_time()

        let result1 = solvePart1()

        var formattedDuration = String(format: "%.6f", getSecondsFromMachTimer(duration: mach_absolute_time() - startTime))

        print(" -> Part 1: \(result1). Solved in \(formattedDuration) seconds")

        if part1Expected != result1 {
            print(" -> ⛔️ Part 1 expected result is: \(part1Expected).")
        }

        // part 2
        startTime = mach_absolute_time()

        let result2 = solvePart2()

        formattedDuration = String(format: "%.6f", getSecondsFromMachTimer(duration: mach_absolute_time() - startTime))

        print(" -> Part 2: \(result2). Solved in \(formattedDuration) seconds")

        if part2Expected != result2 {
            print(" -> ⛔️ Part 2 expected result is: \(part2Expected).")
        }
    }
}
