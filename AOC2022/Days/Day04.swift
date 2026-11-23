import Foundation
import AOCTools

public class Day04: AOCDay {
    public var dayNum: Int = 4
    public var part1Expected: Int = 547
    public var part2Expected: Int = 843
    public var part2ExpectedSample = 4
    
    var pairs: [(ClosedRange<Int>, ClosedRange<Int>)] = []

    public func parseInput() {
        let contents = AOCTools.getRawInputStringForDay(dayNum, in: Bundle.module).allLines()
        contents.forEach{ line in
            let parts = line.components(separatedBy: ",")
            guard parts.count == 2 else {
                return
            }
            
            let range1Components = parts[0].components(separatedBy: "-")
            guard range1Components.count == 2 else {
                return
            }
            let range1: ClosedRange<Int> = ClosedRange(uncheckedBounds: (lower: Int(range1Components[0]) ?? Int.min, upper: Int(range1Components[1]) ?? Int.max))
            
            let range2Components = parts[1].components(separatedBy: "-")
            guard range2Components.count == 2 else {
                return
            }
            let range2: ClosedRange<Int> = ClosedRange(uncheckedBounds: (lower: Int(range2Components[0]) ?? Int.min, upper: Int(range2Components[1]) ?? Int.max))
            
            pairs.append((range1, range2))
        }
    }

    public func solvePart1() -> Int {
        var count = 0
        
        pairs.forEach{ pair in
            if pair.0.contains(pair.1) || pair.1.contains(pair.0) {
                count += 1
            }
        }
        
        return count
    }

    public func solvePart2() -> Int {
        var count = 0
        
        pairs.forEach{ pair in
            let min0 = pair.0.lowerBound
            let max0 = pair.0.upperBound
            
            let min1 = pair.1.lowerBound
            let max1 = pair.1.upperBound
            
            if pair.0.contains(pair.1) || pair.1.contains(pair.0) || (min0 <= max1 && min1 <= max0) {
//            if pair.0.overlaps(pair.1) {
                count += 1
            }
        }
        
        return count
    }
}
