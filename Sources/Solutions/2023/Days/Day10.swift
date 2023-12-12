import Foundation
import Tools

final class Day10Solver: DaySolver {
    let dayNumber: Int = 10

    let expectedPart1Result = 0
    let expectedPart2Result = 0

    private var input: Input!

    private struct Input {
        var rows: [[String]]
        var cols: [[String]]
    }

    func solvePart1() -> Int {
        0
    }

    func solvePart2() -> Int {
        0
    }

    func parseInput(rawString: String) {
        let lines = rawString.allLines()
        var rows: [[String]] = []
        var cols: [[String]] = []

        for rowIdx in 0 ..< lines.count {
            let row = lines[rowIdx]
            for colIdx in 0 ..< row.count {
                cols[colIdx].append(row[colIdx])
            }
            rows.append(row.components(separatedBy: ""))
        }

        var i = 0

        while i < rows.count {
            if !rows[i].contains("#") {
                rows.insert(rows[i], at: i)
                i += 1
            }
            i += 1
        }

        i = 0
        while i < rows[0].count {
            if !cols[i].contains("#") {
                cols.insert(cols[i], at: i)
                i += 1
            }
            i += 1
        }

        input = .init(rows: rows, cols: cols)
    }
}
