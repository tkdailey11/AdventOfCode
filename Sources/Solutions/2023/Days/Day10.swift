import Foundation
import Tools
import Collections

final class Day10Solver: DaySolver {
    let dayNumber: Int = 10

    private enum TileType: String {
        case start = "S"
        case vertical = "|"
        case horizontal = "-"
        case bend_N_E = "L"
        case bend_N_W = "J"
        case bend_S_W = "7"
        case bend_S_E = "F"
        case ground = "."
    }
    
    private struct Tile: Hashable {
        var point: Point2D
        var type: TileType
    }
    
    private struct TileGrid: DFSGrid {

        var points: Set<Tile>
        
        func reachableNeighborsAt(position: Point2D) -> [Point2D] {
            guard let posTile = points.first(where: { $0.point == position }) else {
                return []
            }
            
            let labeledNeighbors = position.labeledNeighbors()
            
            let neighbors = labeledNeighbors.compactMap{ neighbor in
                guard let neighborTile = points.first(where: {$0.point == neighbor.point}) else {
                    return nil as Point2D?
                }
                
                if neighborTile.type != .ground {
                    let type = neighborTile.type
                    switch neighbor.direction {
                    case .north:
                        if [.vertical, .bend_S_E, .bend_S_W].contains(where: {$0 == type}) {
                            return neighbor.point
                        }
                    case .east, .west:
                        if [.horizontal, .bend_N_E, .bend_N_W, .bend_S_E, .bend_S_W].contains(where: {$0 == type}) {
                            return neighbor.point
                        }
                    case .south:
                        if [.vertical, .bend_N_E, .bend_N_W].contains(where: {$0 == type}) {
                            return neighbor.point
                        }
                    default:
                        return nil
                    }
                }
                return nil
            }
            
            return neighbors
        }
    }
    
    let expectedPart1Result = 8
    let expectedPart2Result = 0

    private var input: Input!

    private struct Input {
        var tiles: TileGrid
    }
    
    func solvePart1() -> Int {
        guard let startTile = input.tiles.points.first(where: {$0.type == .start}) else {
            return -1
        }
        
        let lengths = input.tiles.points.map{ tile in
            let longestPath = DFS.longestPathInGrid(input.tiles, from: startTile.point, to: tile.point)
            return longestPath?.steps ?? 0
        }
        
        return lengths.max() ?? 0
    }

    func solvePart2() -> Int {
        0
    }

    func parseInput(rawString: String) {
        let res = rawString.parseGrid{ s, p in
            return TileType(rawValue: s)!
        }.map{ point, type in
            Tile(point: point, type: type)
        }
        
        input = .init(tiles: TileGrid(points: Set<Tile>(res)))
    }
}
