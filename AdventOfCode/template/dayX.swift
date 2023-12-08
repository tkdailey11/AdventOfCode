//
//  dayX.swift
//  AdventOfCode
//
//  Created by Tyler Dailey on 12/7/23.
//

import Foundation

class DayX: Day {
    var DayNum: Int
    var Part1Test: Bool
    var Part2Test: Bool
    
    init(dayNum: Int, part1Test: Bool, part2Test: Bool) {
        DayNum = dayNum
        Part1Test = part1Test
        Part2Test = part2Test
    }
    
    internal func RunDay() -> Void {
        _ = RunPartOne()
        _ = RunPartTwo()
    }
    
    internal func RunPartOne() -> Int {
        var lines: [String] = []
        if(Part1Test) {
            lines = dayXSampleLines
        } else {
            lines = dayXInputLines
        }
        
        return lines.count
    }

    
    internal func RunPartTwo() -> Int {
        var lines: [String] = []
        if(Part2Test) {
            lines = dayXSampleLines
        } else {
            lines = dayXInputLines
        }
        
        return lines.count
    }
}
