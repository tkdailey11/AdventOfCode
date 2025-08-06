//
//  Day01.swift
//  AdventOfCode
//
//  Created by Tyler Dailey on 8/5/25.
//

import Foundation
import AOCTools

public class Day02: AOCDay {
    public var dayNum: Int = 2
    public var part1Expected: Int = 0
    public var part2Expected: Int = 0
    
    private var reports: [[Int]] = []
    
    public func solvePart1() -> Int {
        reports.reduce(0) { result, report in
            result + (report.isSafeReport() ? 1 : 0)
        }
    }

    public func solvePart2() -> Int {
        0
    }

    public func parseInput() {
        let contents = AOCTools.getRawInputStringForDay(dayNum, in: Bundle(for: Day02.self))
        contents.split(separator: "\n").forEach{ line in
            reports.append(line.split(separator: " ").compactMap { i in
                    Int(i) ?? 0
            })
        }
    }
}

extension Array where Element == Int {
    func isSafeReport() -> Bool {
        let isIncreasing = self.count > 1 ? self[0] < self[1] : true
        var isSafe = true
        self.enumerated().forEach { index, value in
            if isIncreasing {
                if index > 0 {
                    if self[index - 1] > value {
                        isSafe = false
                        return
                    }
                    
                    if self[index] - self[index - 1] > 3 {
                        isSafe = false
                        return
                    }
                }
            } else {
                if index > 0 {
                    if self[index - 1] < value {
                        isSafe = false
                        return
                    }
                    
                    if self[index - 1] - self[index] > 3 {
                        isSafe = false
                        return
                    }
                }
            }
        }
        
        return isSafe
    }
}
