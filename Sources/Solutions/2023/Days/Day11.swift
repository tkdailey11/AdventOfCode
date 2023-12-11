import Foundation
import Tools

final class Day11Solver: DaySolver {
	let dayNumber: Int = 11

	let expectedPart1Result = 0
	let expectedPart2Result = 0

	private var input: Input!
    
    private struct GalaxyRow {
        var points: [GalaxyPoint]
        var yVal: Int
    }
    
    private struct GalaxyCol {
        var points: [GalaxyPoint]
        var xVal: Int
    }
    
    private struct GalaxyPoint {
        var point: Point2D
        var isGalaxy: Bool
    }

	private struct Input {
        var points: [GalaxyPoint]
    }

	func solvePart1() -> Int {
		0
	}

	func solvePart2() -> Int {
		0
	}

	func parseInput(rawString: String) {
        let lines = rawString.allLines().map { $0.components(separatedBy: "") }
        var rows: [[GalaxyPoint]] = []
        var colHasGalaxy: [Bool] = []
        
        for i in 0 ..< lines[0].count {
            colHasGalaxy[i] = false
        }
        
        for i in 0 ..< lines.count {
            var row: [GalaxyPoint] = []
            var foundGalaxy = false
            for j in 0 ..< lines[i].count {
                let isGalaxy = lines[i][j] == "#"
                if isGalaxy {
                    foundGalaxy = true
                    colHasGalaxy[j] = true
                }
                let point = GalaxyPoint(point: Point2D(x: j, y: i), isGalaxy: isGalaxy)
                row.append(point)
            }
            rows.append(row)
            if !foundGalaxy {
                var newRow: [GalaxyPoint] = []
                for j in 0 ..< row.count {
                    let point = GalaxyPoint(point: Point2D(x: j, y: i), isGalaxy: false)
                    newRow.append(point)
                }
                rows.append(newRow)
            }
        }
        
        var rowLength = rows[0].count + colHasGalaxy.filter{ $0 }.count
        var newRows: [[GalaxyPoint]] = []
        var offset = 0
        for i in 0 ..< rows.count {
            var newRow: [GalaxyPoint] = []
            for j in 0 ..< rowLength {
                let pt = rows[i][j]
                newRow.append(GalaxyPoint(point: Point2D(x: pt.point.x + offset, y: pt.point.y), isGalaxy: pt.isGalaxy))
                if colHasGalaxy[j] {
                    newRow.append(GalaxyPoint(point: Point2D(x: pt.point.x + offset + 1, y: pt.point.y), isGalaxy: pt.isGalaxy))
                    offset += 1
                }
            }
        }
        
        
        input = .init(points: newRows.flatMap{ $0 })
	}
    
    private func isColEmptySpace(index: Int, rows: [[GalaxyPoint]]) -> Bool {
        for i in 0 ..< input.points.count {
            if rows[i][index].isGalaxy {
                return false
            }
        }
        return true
    }
}
