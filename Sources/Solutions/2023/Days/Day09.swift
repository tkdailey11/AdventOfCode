import Foundation
import Tools

final class Day09Solver: DaySolver {
    let dayNumber: Int = 9

    let expectedPart1Result = 1_992_273_652
    let expectedPart2Result = 1012

    private var input: Input!

    private struct Input {
        var numLines: [[Int]]
    }

    private func getDiffs(_ sequence: [Int]) -> [Int] {
        sequence.dropFirst().enumerated().map {
            $0.element - sequence[$0.offset]
        }
    }

    private func createLayers(_ sequence: [Int]) -> [[Int]] {
        var layers: [[Int]] = [sequence]

        // if this returns 1 it means every value is the same
        while Set(layers.last!).count > 1 {
            layers.append(getDiffs(layers.last!))
        }

        return layers
    }

    func solvePart1() -> Int {
        input.numLines.reduce(0) { result, line in
            let layers = createLayers(line)

            return result + layers.compactMap(\.last).reduce(0, +)
        }
    }

    func solvePart2() -> Int {
        input.numLines.reduce(0) { result, line in
            let layers = createLayers(line)

            return result + layers.reversed().compactMap(\.first).reduce(0) { $1 - $0 }
        }
    }

    func parseInput(rawString: String) {
        input = .init(numLines: rawString.allLines().map { $0.components(separatedBy: " ").compactMap(Int.init) })
    }
}
