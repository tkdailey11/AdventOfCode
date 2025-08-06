//
//  Day01.swift
//  AdventOfCode
//
//  Created by Tyler Dailey on 8/5/25.
//

import Foundation
import AOCTools

public class Day01: AOCDay {
    public var dayNum: Int = 1
    public var part1Expected: Int = 2285373
    public var part2Expected: Int = 21142653
    
    private var column1: [Int] = []
    private var column2: [Int] = []


    public func solvePart1() -> Int {
        var distance = 0
        for (index, element) in column1.enumerated() {
            distance += abs(element - column2[index])
        }
        return distance
    }

    public func solvePart2() -> Int {
        let column2Histogram = column2.histogram
        return column1.reduce(0) { result, element in
            result + (element * (column2Histogram[element] ?? 0))
        }
    }

    public func parseInput() {
        let contents = AOCTools.getRawInputStringForDay(1, in: Bundle(for: Day01.self))
        contents.split(separator: "\n").forEach{ line in
            let columns = line.split(separator: " ")
            if columns.count == 2 {
                column1.append(Int(columns[0])!)
                column2.append(Int(columns[1])!)
            }
        }
        
        column1.sort()
        column2.sort()
    }
}
