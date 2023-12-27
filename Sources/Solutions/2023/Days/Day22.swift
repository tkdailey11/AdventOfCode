import Foundation
import Tools

final class Day22Solver: DaySolver {
    let dayNumber: Int = 22

    let expectedPart1Result = 0
    let expectedPart2Result = 0

    private struct Brick {
        var end1: Point3D
        var end2: Point3D
    }
    
    private var input: Input!

    private struct Input {
        var bricks: [Brick]
    }

    func solvePart1() -> Int {
        0
    }

    func solvePart2() -> Int {
        0
    }

    func parseInput(rawString: String) {
        input = .init(bricks: rawString.allLines().map{ line in
            let parts = line.components(separatedBy: CharacterSet(charactersIn: "~"))
            return Brick(end1: Point3D(commaSeparatedString: parts[0]), end2: Point3D(commaSeparatedString: parts[1]))
        })
    }
}
