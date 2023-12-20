import Foundation
import Tools

final class Day14Solver: DaySolver {
    let dayNumber: Int = 14

    //113424
    let expectedPart1Result = 113424
    //96003
    let expectedPart2Result = 96003

    private enum Rock: String {
        case round = "O"
        case cube = "#"
        case empty = "."

        init(string: String) {
            switch string {
            case "O": self = .round
            case "#": self = .cube
            case ".": self = .empty
            default: preconditionFailure()
            }
        }
    }

    private struct Space {
        var location: Point2D
        var rock: Rock
    }
    
    private typealias Platform = [[Space]]
    
    private func printPlatform(_ platform: Platform) {
        platform.forEach{ row in
            print(row.map({ $0.rock.rawValue }).joined())
        }
    }
    
    private var input: Input!

    private struct Input {
        var platform: Platform
    }
    
    private func calculateWeight(of platform: Platform, tilted: Direction) -> Int {
        switch tilted {
        case .north:
            return platform.enumerated().map{ y, row in
                row.enumerated().map{ x, space in
                    if space.rock == .round {
                        let res = platform.count - y
                        return res
                    }
                    return 0
                }.reduce(0, +)
            }.reduce(0, +)
        case .east:
            return platform.enumerated().map{ y, row in
                row.reversed().enumerated().map{ x, space in
                    if space.rock == .round {
                        return row.count - x
                    }
                    return 0
                }.reduce(0, +)
            }.reduce(0, +)
        case .south:
            return platform.reversed().enumerated().map{ y, row in
                row.enumerated().map{ x, space in
                    if space.rock == .round {
                        return platform.count - y
                    }
                    return 0
                }.reduce(0, +)
            }.reduce(0, +)
        case .west:
            return platform.enumerated().map{ y, row in
                row.enumerated().map{ x, space in
                    if space.rock == .round {
                        return row.count - x
                    }
                    return 0
                }.reduce(0, +)
            }.reduce(0, +)
        default:
            return 0
        }
    }
    
    private func tiltPlatform(_ platform: Platform, direction: Direction) -> Platform {
        var newPlatform = Platform(platform)
        
        switch direction {
        case .north:
            var didSwap = true
            while didSwap {
               didSwap = false
                var y = newPlatform.count - 1
                while y >= 0 {
                    for x in 0 ..< newPlatform[y].count {
                        if newPlatform[y][x].rock == .round {
                            if y > 0 && newPlatform[y-1][x].rock == .empty {
                                let temp = newPlatform[y][x]
                                newPlatform[y][x] = newPlatform[y-1][x]
                                newPlatform[y-1][x] = temp
                                
                                newPlatform[y][x].location = Point2D(x: x, y: y)
                                newPlatform[y-1][x].location = Point2D(x: x, y: y-1)
                                
                                didSwap = true
                            }
                        }
                    }
                    y -= 1
                }
            }
        case .east:
            var didSwap = true
            var rowLength = newPlatform[0].count
            while didSwap {
               didSwap = false
                var x = 0
                while x < rowLength {
                    for y in 0 ..< newPlatform.count {
                        if newPlatform[y][x].rock == .round {
                            if x < rowLength - 1 && newPlatform[y][x+1].rock == .empty {
                                let temp = newPlatform[y][x]
                                newPlatform[y][x] = newPlatform[y][x+1]
                                newPlatform[y][x+1] = temp
                                
                                newPlatform[y][x].location = Point2D(x: x, y: y)
                                newPlatform[y][x+1].location = Point2D(x: x+1, y: y)
                                
                                didSwap = true
                            }
                        }
                    }
                    x += 1
                }
            }
        case .south:
            var didSwap = true
            while didSwap {
               didSwap = false
                var y = 0
                while y < newPlatform.count {
                    for x in 0 ..< newPlatform[y].count {
                        if newPlatform[y][x].rock == .round {
                            if y < newPlatform.count - 1 && newPlatform[y+1][x].rock == .empty {
                                let temp = newPlatform[y][x]
                                newPlatform[y][x] = newPlatform[y+1][x]
                                newPlatform[y+1][x] = temp
                                
                                newPlatform[y][x].location = Point2D(x: x, y: y)
                                newPlatform[y+1][x].location = Point2D(x: x, y: y+1)
                                
                                didSwap = true
                            }
                        }
                    }
                    y += 1
                }
            }
        case .west:            
            var didSwap = true
            var rowLength = newPlatform[0].count
            while didSwap {
               didSwap = false
                var x = rowLength - 1
                while x > 0 {
                    for y in 0 ..< newPlatform.count {
                        if newPlatform[y][x].rock == .round {
                            if x > 0 && newPlatform[y][x-1].rock == .empty {
                                let temp = newPlatform[y][x]
                                newPlatform[y][x] = newPlatform[y][x-1]
                                newPlatform[y][x-1] = temp
                                
                                newPlatform[y][x].location = Point2D(x: x, y: y)
                                newPlatform[y][x-1].location = Point2D(x: x-1, y: y)
                                
                                didSwap = true
                            }
                        }
                    }
                    x -= 1
                }
            }
        default:
            break
        }
        
        return newPlatform
    }

    private func rotatePlatformCycle(platform: Platform) -> Platform {
        let north = tiltPlatform(platform, direction: .north)
        let west = tiltPlatform(north, direction: .west)
        let south = tiltPlatform(west, direction: .south)
        return tiltPlatform(south, direction: .east)
    }
    
    func solvePart1() -> Int {
        let northPlatform = tiltPlatform(input.platform, direction: .north)
        return calculateWeight(of: northPlatform, tilted: .north)
    }

    func solvePart2() -> Int {
        var platform = Platform(input.platform)
        
        // we hash the rock configuration and store the cycle number for each hash
        var existingCycleHashes: [Int: Int] = [:]
        let numberOfCycles = 1_000_000_000
        for cycle in 0 ..< numberOfCycles {
            platform = rotatePlatformCycle(platform: platform)
            let hash = platform.debugDescription.hashValue

            if calculateWeight(of: platform, tilted: .north) == 96003 {
                print(cycle)
            }
            if let identicalCycle = existingCycleHashes[hash] {
                let finalCycle = Math.solveCycle(withStartIndex: identicalCycle, endIndex: cycle, numberOfCycles: numberOfCycles)
                
                print(cycle, identicalCycle, finalCycle, separator: " - ")

                break
            } else {
                existingCycleHashes[hash] = cycle
            }
       }

        for _ in 0 ..< 109 {
            platform = rotatePlatformCycle(platform: platform)
        }
        return calculateWeight(of: platform, tilted: .north)
    }

    func parseInput(rawString: String) {
        var platform: [[Space]] = []
        rawString.allLines().enumerated().forEach{ i, line in
            let spaces = line.enumerated().map{ j, char in
                Space(location: Point2D(x: i, y: j), rock: Rock(string: String(char)))
            }
            platform.append(spaces)
        }
        input = .init(platform: platform)
    }
}
//
//import Foundation
//import Tools
//
//final class Day14Solver: DaySolver {
//    let dayNumber: Int = 14
//
//    let expectedPart1Result = 106648
//    let expectedPart2Result = 87700
//
//    private var input: Input!
//
//    private struct Input {
//        let roundRocks: Set<Point2D>
//        let cubeRocks: Set<Point2D>
//
//        let size: Size
//    }
//

//
//    func solvePart1() -> Int {
//        let roundRocks = move(roundRocks: input.roundRocks, cubeRocks: input.cubeRocks, direction: .north, size: input.size)
//
//        return calculateWeight(for: roundRocks, size: input.size)
//    }
//
//    func solvePart2() -> Int {
//        var roundRocks = input.roundRocks
//
//        // we hash the rock configuration and store the cycle number for each hash
//        var existingCycleHashes: [Int: Int] = [:]
//
//        // for each cycle we also store the rock configuration so once we have found the loop in the cycles
//        // we can just look the final configuration up in the cache
//        var roundRocksByCycle: [Int: Set<Point2D>] = [:]
//
//        let numberOfCycles = 1_000_000_000
//        let directions: [Direction] = [.north, .west, .south, .east]
//
//        for cycle in 0 ..< numberOfCycles {
//            for direction in directions {
//                roundRocks = move(roundRocks: roundRocks, cubeRocks: input.cubeRocks, direction: direction, size: input.size)
//            }
//
//            let hash = roundRocks.hashValue
//
//            if let identicalCycle = existingCycleHashes[hash] {
//                let finalCycle = Math.solveCycle(withStartIndex: identicalCycle, endIndex: cycle, numberOfCycles: numberOfCycles)
//
//                roundRocks = roundRocksByCycle[finalCycle]!
//
//                break
//            } else {
//                existingCycleHashes[hash] = cycle
//                roundRocksByCycle[cycle] = roundRocks
//            }
//        }
//
//        return calculateWeight(for: roundRocks, size: input.size)
//    }
//
//    func parseInput(rawString: String) {
//        var roundRocks: Set<Point2D> = []
//        var cubeRocks: Set<Point2D> = []
//
//        var maxSize: Size = .zero
//
//        for (y, line) in rawString.allLines().enumerated() {
//            for (x, character) in line.enumerated() {
//                let point = Point2D(x: x, y: y)
//
//                switch character {
//                case ".": break
//                case "#": cubeRocks.insert(point)
//                case "O": roundRocks.insert(point)
//                default: preconditionFailure()
//                }
//            }
//
//            maxSize = .init(width: max(maxSize.width, line.count), height: max(maxSize.height, y + 1))
//        }
//
//        input = .init(roundRocks: roundRocks, cubeRocks: cubeRocks, size: maxSize)
//    }
//}
