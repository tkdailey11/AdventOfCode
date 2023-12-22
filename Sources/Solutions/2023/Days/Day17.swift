
//    // 1260
//    let expectedPart1Result = 102
//    // 1421
//    let expectedPart2Result = 0
import Collections
import Foundation
import Tools

final class Day17Solver: DaySolver {
    let dayNumber: Int = 17

    let expectedPart1Result = 102
    let expectedPart2Result = 94
    
    private var minimums: [Int:Int] = [:]

    private var input: Input!

    private struct Input {
        let grid: [[Int]]
    }
    
    private func populateMinimums(size: Size) -> [[Int]] {
        var minimums: [[Int]] = []
        for _ in 0 ..< size.height {
            var row: [Int] = []
            for _ in 0 ..< size.width {
                row.append(Int.max)
            }
            minimums.append(row)
        }
        return minimums
    }

    private struct QueueNode: Comparable {
        let point: Point2D
//        let direction: Direction
//        let directionCount: Int
        let weight: Int

        static func < (lhs: QueueNode, rhs: QueueNode) -> Bool {
            lhs.weight < rhs.weight
        }
    }
    
    private func solve(size: Size) {
        let a = Point2D(x: 0, y: 0)
        let b = Point2D(x: size.width - 1, y: size.height - 1)
        
        var priorityQueue = PriorityQueue<QueueNode>(isAscending: true)
        priorityQueue.push(.init(point: a, weight: 0))
        
        while let node = priorityQueue.pop() {
            if node.point == b {
                return
            }
 
            Direction.allStraight.forEach{ direction in
                let newPoint = node.point.moved(to: direction)
                if (0 ..< size.width).contains(newPoint.x) && (0 ..< size.height).contains(newPoint.y) {
                    let hash = newPoint.hashValue
                    let weight = node.weight + input.grid[newPoint.y][newPoint.x]
                    if weight < minimums[hash] ?? Int.max {
                        priorityQueue.push(QueueNode(point: newPoint, weight: weight))
                        minimums[hash] = weight
                    }
                }
            }
        }
    }
/**
    private func solve(withGrid grid: [[Int]], minRepeating: Int, maxRepeating: Int) -> Int {
        let size = Size(width: grid[0].count, height: grid.count)

        let a = Point2D(x: 0, y: 0)
        let b = Point2D(x: size.width - 1, y: size.height - 1)

        var priorityQueue = PriorityQueue<QueueNode>(isAscending: true)

        var weights: [Int: Int] = [
            UniqueState(point: .zero, direction: .east, directionCount: 0).hashValue: 0,
        ]

        priorityQueue.push(.init(point: a, direction: .east, directionCount: 0, weight: 0))

        while let solution = priorityQueue.pop() {
            if solution.point == b {
                return solution.weight
            }

            guard let currentWeight = weights[UniqueState(point: solution.point, direction: solution.direction, directionCount: solution.directionCount).hashValue] else {
                preconditionFailure()
            }

            let newDirections: [Direction]

            let lastDirection = solution.direction

            if minRepeating > 0, solution.directionCount < minRepeating {
                newDirections = [lastDirection]
            } else if solution.directionCount >= maxRepeating {
                newDirections = [
                    lastDirection.left,
                    lastDirection.right,
                ]
            } else {
                newDirections = [
                    lastDirection.left,
                    lastDirection,
                    lastDirection.right,
                ]
            }

            for newDirection in newDirections {
                let newPoint = solution.point.moved(to: newDirection)

                guard (0 ..< size.width).contains(newPoint.x) && (0 ..< size.height).contains(newPoint.y) else {
                    continue
                }

                let directionCount = (newDirection == solution.direction) ? (solution.directionCount + 1) : 1

                if newPoint == b, minRepeating > 0, directionCount < minRepeating {
                    continue
                }

                let stateHash = UniqueState(
                    point: newPoint,
                    direction: newDirection,
                    directionCount: directionCount
                ).hashValue

                let oldWeight = weights[stateHash]

                let combinedWeight = currentWeight + grid[newPoint.y][newPoint.x]

                if oldWeight == nil || combinedWeight < oldWeight! {
                    weights[stateHash] = combinedWeight

                    priorityQueue.push(
                        QueueNode(
                            point: newPoint,
                            direction: newDirection,
                            directionCount: directionCount,
                            weight: combinedWeight
                        )
                    )
                }
            }
        }

        preconditionFailure()
    }
*/
    func solvePart1() -> Int {
        let size = Size(width: input.grid[0].count, height: input.grid.count)
        minimums = [:]
        solve(size: size)
        return 0
        //return solve(withGrid: input.grid, minRepeating: 0, maxRepeating: 3)
    }

    func solvePart2() -> Int {
        0
        //return solve(withGrid: input.grid, minRepeating: 4, maxRepeating: 10)
    }

    func parseInput(rawString: String) {
        var grid: [[Int]] = []

        rawString.allLines().enumerated().forEach { _, line in
            grid.append(line.map { String($0) }.compactMap(Int.init))
        }

        input = .init(grid: grid)
    }
}
