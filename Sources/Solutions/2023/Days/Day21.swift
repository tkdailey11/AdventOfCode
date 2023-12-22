import Foundation
import Tools
import Collections

final class Day21Solver: DaySolver {
    let dayNumber: Int = 21

    let expectedPart1Result = 0
    let expectedPart2Result = 0
    
    private enum SpaceType: String {
        case plot = "."
        case rock = "#"
        case start = "S"
    }
    
    private struct GardenSpace: Hashable {
        var point: Point2D
        var type: SpaceType
    }

    private var input: Input!

    private struct Input {
        var spaces: Set<GardenSpace>
        var startSpace: GardenSpace
    }

    func solvePart1() -> Int {
        var toVisit: Set<GardenSpace> = [input.startSpace]
        var stepsRemaining = 64
        while stepsRemaining > 0 {
            var newSpaces:  Set<GardenSpace> = []
            toVisit.forEach { space in
                space.point.neighbors().forEach { neighbor in
                    if let space = input.spaces.first(where: {$0.point == neighbor}) {
                        if space.type == .start || space.type == .plot {
                            newSpaces.insert(space)
                        }
                    }
                }
            }
            
            toVisit = newSpaces
            stepsRemaining -= 1
        }
        
        return toVisit.count
    }

    func solvePart2() -> Int {
        0
    }

    func parseInput(rawString: String) {
        var gardenSet = Set<GardenSpace>()
        var startSpace = GardenSpace(point: Point2D(), type: .rock)
        rawString.allLines().enumerated().forEach{ row, line in
            line.enumerated().forEach{ col, char in
                if String(char) == "S" {
                    startSpace = GardenSpace(point: Point2D(x: col, y: row), type: .start)
                }
                gardenSet.insert(GardenSpace(point: Point2D(x: col, y: row), type: SpaceType(rawValue: String(char)) ?? .rock))
            }
        }

        input = .init(spaces: gardenSet, startSpace: startSpace)
    }
}
