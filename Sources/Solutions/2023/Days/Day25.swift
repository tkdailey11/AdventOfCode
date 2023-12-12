import Foundation
import Tools

final class Day25Solver: DaySolver {
    let dayNumber: Int = 25

    let expectedPart1Result = 0
    let expectedPart2Result = "Merry Christmas 🎄"

    private var input: Input!

    private struct Input {}

    func solvePart1() -> Int {
        0
    }

    func solvePart2() -> String {
        "Merry Christmas 🎄"
    }

    func parseInput(rawString: String) {
        _ = rawString.allLines()
        input = .init()
    }
}
