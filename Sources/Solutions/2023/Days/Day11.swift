import Foundation
import Tools

final class Day11Solver: DaySolver {
    let dayNumber: Int = 11

    let expectedPart1Result = 9370588
    let expectedPart2Result = 746207878188

    private var input: Input!

    private struct Input {
        var galaxies: Set<Point2D>
    }

    private func expandColumns(in galaxies: Set<Point2D>, scale: Int) -> Set<Point2D> {
        var newGalaxies: Set<Point2D> = []

            let maxX = galaxies.map(\.x).max()!

            var newX = 0
            for x in 0 ... maxX {
                let existingGalaxiesOnColumn = galaxies.filter { $0.x == x }

                if existingGalaxiesOnColumn.isEmpty {
                    newX += scale
                } else {
                    newGalaxies = newGalaxies.union(existingGalaxiesOnColumn.map { .init(x: newX, y: $0.y) })

                    newX += 1
                }
            }

            return newGalaxies
    }

    private func expandRows(in galaxies: Set<Point2D>, scale: Int) -> Set<Point2D> {
        var newGalaxies: Set<Point2D> = []

                let maxY = galaxies.map(\.y).max()!

                var newY = 0
                for y in 0 ... maxY {
                    let existingGalaxiesOnRow = galaxies.filter { $0.y == y }

                    if existingGalaxiesOnRow.isEmpty {
                        newY += scale
                    } else {
                        newGalaxies = newGalaxies.union(existingGalaxiesOnRow.map { .init(x: $0.x, y: newY) })

                        newY += 1
                    }
                }

                return newGalaxies
    }

    private func calculateTotalDistanceWith(_ originalGalaxies: Set<Point2D>, scale: Int) -> Int {
//        var expanded = expandColumns(in: input.galaxies, scale: scale)
//        expanded = expandRows(in: expanded, scale: scale)
//
//        return expanded
//            .compactMap { galaxy in
//                expanded.remove(galaxy)
//                return expanded.map { galaxy.manhattanDistance(from: $0) }
//            }
//            .flatMap { $0 }
//            .reduce(0) { $0 + $1 }
        var expandedGalaxies = expandColumns(in: originalGalaxies, scale: scale)
        expandedGalaxies = expandRows(in: expandedGalaxies, scale: scale)

        let galaxies = Array(expandedGalaxies)

        var sum = 0
        for i in 0 ..< galaxies.count {
            for j in i + 1 ..< galaxies.count {
                sum += galaxies[i].manhattanDistance(from: galaxies[j])
            }
        }

        return sum
    }
    
    func solvePart1() -> Int {
        calculateTotalDistanceWith(input.galaxies, scale: 2)
    }

    func solvePart2() -> Int {
        calculateTotalDistanceWith(input.galaxies, scale: 1_000_000)
    }

    func parseInput(rawString: String) {
        var galaxies: Set<Point2D> = Set()
        rawString.allLines().enumerated().forEach { y, line in
            line.enumerated().forEach { x, char in
                if char == "#" {
                    galaxies.insert(Point2D(x: x, y: y))
                }
            }
        }

        input = .init(galaxies: galaxies)
    }
}
