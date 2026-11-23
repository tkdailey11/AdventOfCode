import Foundation
import AOCTools

public class Day01: AOCDay {
    public var dayNum: Int = 1
    public var part1Expected: Int = 69836
    public var part2Expected: Int = 207968
    
    struct CalorieList {
        var values: [Int]
        var sum: Int
        
        init(values: [Int], sum: Int) {
            self.values = values
            self.sum = sum
        }
        
        init() {
            self.values = []
            self.sum = 0
        }
        
        mutating func addValue(_ value: Int) {
            self.values.append(value)
            self.sum += value
        }
    }
    
    private var calorieLists: [CalorieList] = []
    private var sumSet: Set<Int> = Set()

    public func parseInput() {
        let contents = AOCTools.getRawInputStringForDay(dayNum, in: Bundle.module).allLines(includeEmpty: true)
        
        var currList: CalorieList = .init()
        contents.forEach{ line in
            if line.isEmpty {
                calorieLists.append(currList)
                sumSet.insert(currList.sum)
                currList = .init()
            } else {
                currList.addValue(Int(line) ?? 0)
            }
        }
        
        calorieLists.sort{ $1.sum > $0.sum }
    }

    public func solvePart1() -> Int {
        calorieLists[calorieLists.count - 1].sum
    }

    public func solvePart2() -> Int {
        var sum = sumSet.pop() ?? 0
        sum += sumSet.pop() ?? 0
        sum += sumSet.pop() ?? 0
        return sum
    }
}
