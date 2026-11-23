import Foundation
import AOCTools

public class Day03: AOCDay {
    public var dayNum: Int = 3
    public var part1Expected: Int = 7826
    public var part2Expected: Int = 2577

    struct Packs {
        let pack1: Set<Int>
        let pack2: Set<Int>
    }
    
    var allPacks: [Packs] = []
    
    func encodeAlpha(_ s: String) -> [Int] {
        s.utf8.compactMap { byte in
            switch byte {
            case 97...122: return Int(byte) - 96  // 'a'...'z' -> 1...26
            case 65...90:  return Int(byte) - 38  // 'A'...'Z' -> 27...52
            default:       return nil
            }
        }
    }
    
    public func parseInput() {
        let contents = AOCTools.getRawInputStringForDay(dayNum, in: Bundle.module).allLines()
        contents.forEach{ line in
            let arr = encodeAlpha(line)
            let packSize = Int(line.count/2)
            let pack1: Set<Int> = .init(arr.prefix(packSize))
            let pack2: Set<Int> = .init(arr.suffix(from: packSize))
            
            allPacks.append(.init(pack1: pack1, pack2: pack2))
        }
    }

    public func solvePart1() -> Int {
        allPacks.reduce(0){ sum, packs in
            sum + Int(packs.pack1.intersection(packs.pack2).reduce(0){sum2, item in
                sum2 + Int(item)
            })
        }
    }

    public func solvePart2() -> Int {
        var sum = 0
        allPacks.chunked(into: 3).forEach{ chunk in
            var chunkSets: [Set<Int>] = []
            chunk.forEach{ pack in
                chunkSets.append(pack.pack1.union(pack.pack2))
            }
            
            var intersection: Set<Int> = chunkSets.first ?? .init()
            chunkSets.forEach{ set in
                intersection = intersection.intersection(set)
            }
            
            sum += intersection.reduce(0){ sum2, item in
                sum2 + item
            }
        }
        
        return sum
    }
}
