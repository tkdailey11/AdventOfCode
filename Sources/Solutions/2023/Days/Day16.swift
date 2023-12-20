//import Collections
//import Foundation
//import Tools
//
//final class Day16Solver: DaySolver {
//    let dayNumber: Int = 16
//
//    let expectedPart1Result = 7074
//    // Greater than 7147
//    let expectedPart2Result = 0
//    
//    private enum SpaceType: Equatable, Comparable, Hashable {
//        case empty
//        case mirrorF
//        case mirrorB
//        case splitV
//        case splitH
//        
//        init(string: String) {
//            switch string {
//            case ".": self = .empty
//            case "/": self = .mirrorF
//            case "\\": self = .mirrorB
//            case "|": self = .splitV
//            case "-": self = .splitH
//            default:
//                preconditionFailure()
//            }
//        }
//    }
//    
//    private struct Space: Hashable {
//        var point: Point2D
//        var type: SpaceType
//    }
//    
//    private struct Tile: Hashable, Equatable {
//        var point: Point2D
//        var direction: Direction
//    }
//
//    private var input: Input!
//
//    private struct Input {
//        var spaces: Set<Space>
//        var maxX: Int
//        var maxY: Int
//    }
//    
//    private func isValidNeighbor(_ neighbor: Point2D) -> Bool {
//        return neighbor.y >= 0 && neighbor.y <= input.maxY && neighbor.x >= 0 && neighbor.x <= input.maxX
//    }
//    
//    private func printGrid(points: Set<Tile>) {
//        var strings: [[String]] = []
//        for y in 0 ... input.maxY {
//            var line: [String] = []
//            for x in 0 ... input.maxX {
//                if let point = points.first(where: {$0.point.x == x && $0.point.y == y}) {
//                    line.append("#")
//                } else {
//                    line.append(".")
//                }
//            }
//            strings.append(line)
//        }
//        
//        strings.reversed().forEach{ line in
//            print(line.joined())
//        }
//    }
//    
//    private func getVisitedPointCount(tile: Tile) -> Int {
//        var visited: Set<Tile> = []
//        var stack: Deque<Tile> = Deque([tile])
//        
//        while stack.count > 0 {
//            guard let item = stack.popFirst() else {
//                break
//            }
//            
//            if visited.contains(where: { $0.point.x == item.point.x && $0.point.y == item.point.y && $0.direction == item.direction }) {
//                continue
//            }
//            
//            visited.insert(Tile(point: item.point, direction: item.direction))
//            
//            let nextPoint = item.point.moved(to: item.direction)
//            
//            if isValidNeighbor(nextPoint) {
//                guard let space = input.spaces.first(where: { $0.point.x == nextPoint.x && $0.point.y == nextPoint.y }) else {
//                    continue
//                }
//                
//                switch item.direction {
//                case .south:
//                    switch space.type {
//                    case .empty:
//                        stack.append(Tile(point: nextPoint, direction: .south))
//                    case .splitH:
//                        stack.append(Tile(point: nextPoint, direction: .east))
//                        stack.append(Tile(point: nextPoint, direction: .west))
//                    case .splitV:
//                        stack.append(Tile(point: nextPoint, direction: .south))
//                    case .mirrorB:
//                        stack.append(Tile(point: nextPoint, direction: .west))
//                    case .mirrorF:
//                        stack.append(Tile(point: nextPoint, direction: .east))
//                    }
//                case .east:
//                    switch space.type {
//                    case .empty:
//                        stack.append(Tile(point: nextPoint, direction: .east))
//                    case .splitH:
//                        stack.append(Tile(point: nextPoint, direction: .east))
//                    case .splitV:
//                        stack.append(Tile(point: nextPoint, direction: .south))
//                        stack.append(Tile(point: nextPoint, direction: .north))
//                    case .mirrorB:
//                        stack.append(Tile(point: nextPoint, direction: .north))
//                    case .mirrorF:
//                        stack.append(Tile(point: nextPoint, direction: .south))
//                    }
//                case .north:
//                    switch space.type {
//                    case .empty:
//                        stack.append(Tile(point: nextPoint, direction: .north))
//                    case .splitH:
//                        stack.append(Tile(point: nextPoint, direction: .east))
//                        stack.append(Tile(point: nextPoint, direction: .west))
//                    case .splitV:
//                        stack.append(Tile(point: nextPoint, direction: .north))
//                    case .mirrorB:
//                        stack.append(Tile(point: nextPoint, direction: .east))
//                    case .mirrorF:
//                        stack.append(Tile(point: nextPoint, direction: .west))
//                    }
//                default:
//                    switch space.type {
//                    case .empty:
//                        stack.append(Tile(point: nextPoint, direction: .west))
//                    case .splitH:
//                        stack.append(Tile(point: nextPoint, direction: .west))
//                    case .splitV:
//                        stack.append(Tile(point: nextPoint, direction: .south))
//                        stack.append(Tile(point: nextPoint, direction: .north))
//                    case .mirrorB:
//                        stack.append(Tile(point: nextPoint, direction: .south))
//                    case .mirrorF:
//                        stack.append(Tile(point: nextPoint, direction: .north))
//                    }
//                }
//            }
//        }
//
//        var visitedPoints: Set<Point2D> = []
//        visited.forEach{ pv in
//            visitedPoints.insert(pv.point)
//        }
//        return visitedPoints.count
//    }
//
//    func solvePart1() -> Int {
//        getVisitedPointCount(tile: Tile(point: Point2D(x: 0, y: input.maxY), direction: .north))
//    }
//
//    func solvePart2() -> Int {
//        var results: [Int] = []
//        
//        // Top Left
//        results.append(getVisitedPointCount(tile: Tile(point: Point2D(x: 0, y: input.maxY), direction: .north)))
//        results.append(getVisitedPointCount(tile: Tile(point: Point2D(x: 0, y: input.maxY), direction: .east)))
//        
//        // Bottom Left
//        results.append(getVisitedPointCount(tile: Tile(point: Point2D(x: 0, y: 0), direction: .south)))
//        results.append(getVisitedPointCount(tile: Tile(point: Point2D(x: 0, y: 0), direction: .east)))
//        
//        // Top Right
//        results.append(getVisitedPointCount(tile: Tile(point: Point2D(x: input.maxX, y: input.maxY), direction: .west)))
//        results.append(getVisitedPointCount(tile: Tile(point: Point2D(x: input.maxX, y: input.maxY), direction: .north)))
//        
//        results.append(getVisitedPointCount(tile: Tile(point: Point2D(x: input.maxX, y: 0), direction: .west)))
//        results.append(getVisitedPointCount(tile: Tile(point: Point2D(x: input.maxX, y: 0), direction: .south)))
//        
//        return results.max() ?? 0
//    }
//
//    func parseInput(rawString: String) {
//        var spaces: Set<Space> = []
//        let lines = rawString.allLines()
//        lines.enumerated().forEach{ y, line in
//            line.enumerated().forEach{ x, char in
//                spaces.insert(Space(point: Point2D(x: x, y: lines.count - y - 1), type: SpaceType(string: String(char))))
//            }
//        }
//        input = .init(spaces: spaces, maxX: lines[0].count - 1, maxY: lines.count - 1)
//    }
//}

import Collections
import Foundation
import Tools

final class Day16Solver: DaySolver {
    let dayNumber: Int = 16

    let expectedPart1Result = 7074
    let expectedPart2Result = 8239

    private var input: Input!

    private typealias Tiles = [Point2D: Tile]

    private struct Input {
        let tiles: Tiles
    }

    private enum Tile {
        case backslash
        case slash
        case verticalSplitter
        case horizontalSplitter
    }

    private func solveBeamPath(withTiles tiles: Tiles, startPoint: Point2D, direction: Direction) -> Set<Point2D> {
        let maxX = tiles.keys.map(\.x).max()!
        let maxY = tiles.keys.map(\.y).max()!

        struct Item: Hashable {
            let point: Point2D
            let direction: Direction
        }

        var items: Deque<Item> = [.init(point: startPoint, direction: direction)]
        var path: Set<Point2D> = []

        // if we are at the same point in the same direction we should not further process this queue item
        var visitedItems: Set<Item> = []

        itemLoop: while let item = items.popFirst() {
            guard !visitedItems.contains(item) else {
                continue
            }

            visitedItems.insert(item)

            var newDirection = item.direction
            var point = item.point

            // continue till we branch or run out of valid grid area
            while true {
                point = point.moved(to: newDirection)

                // out of range, stop
                if !(0 ... maxX).contains(point.x) || !(0 ... maxY).contains(point.y) {
                    continue itemLoop
                }

                path.insert(point)

                switch tiles[point] {
                case nil: break
                case .backslash:
                    switch newDirection {
                    case .east: newDirection = .south
                    case .west: newDirection = .north
                    case .south: newDirection = .east
                    case .north: newDirection = .west
                    default: preconditionFailure()
                    }
                case .slash:
                    switch newDirection {
                    case .east: newDirection = .north
                    case .west: newDirection = .south
                    case .south: newDirection = .west
                    case .north: newDirection = .east
                    default: preconditionFailure()
                    }
                case .verticalSplitter:
                    switch newDirection {
                    case .east,
                         .west:
                        items.append(.init(point: point, direction: .north))
                        items.append(.init(point: point, direction: .south))

                        continue itemLoop
                    case .north,
                         .south:
                        break
                    default: preconditionFailure()
                    }
                case .horizontalSplitter:
                    switch newDirection {
                    case .north,
                         .south:
                        items.append(.init(point: point, direction: .east))
                        items.append(.init(point: point, direction: .west))

                        continue itemLoop
                    case .east,
                         .west:
                        break
                    default: preconditionFailure()
                    }
                }
            }
        }

        return path
    }

    func solvePart1() -> Int {
        solveBeamPath(withTiles: input.tiles, startPoint: .init(x: -1, y: 0), direction: .east).count
    }

    func solvePart2() -> Int {
        let maxX = input.tiles.keys.map(\.x).max()!
        let maxY = input.tiles.keys.map(\.y).max()!

        var maxCount = Int.min

        for y in 0 ... maxY {
            maxCount = max(maxCount, solveBeamPath(withTiles: input.tiles, startPoint: .init(x: -1, y: y), direction: .east).count)
            maxCount = max(maxCount, solveBeamPath(withTiles: input.tiles, startPoint: .init(x: maxX + 1, y: y), direction: .west).count)
        }

        for x in 0 ... maxX {
            maxCount = max(maxCount, solveBeamPath(withTiles: input.tiles, startPoint: .init(x: x, y: -1), direction: .south).count)
            maxCount = max(maxCount, solveBeamPath(withTiles: input.tiles, startPoint: .init(x: x + 1, y: maxY + 1), direction: .north).count)
        }

        return maxCount
    }

    func parseInput(rawString: String) {
        input = .init(tiles: rawString.parseGrid { character, _ in
            switch character {
            case "\\": Tile.backslash
            case "/": Tile.slash
            case "|": Tile.verticalSplitter
            case "-": Tile.horizontalSplitter
            case ".": nil
            default: preconditionFailure()
            }
        })
    }
}
