//
//  definitions.swift
//  AdventOfCode
//
//  Created by Tyler Dailey on 12/7/23.
//

import Foundation

protocol Day {
    var DayNum: Int { get }
    var Part1Test: Bool { get }
    var Part2Test: Bool { get }
    
    func RunDay() -> Void
    func RunPartOne() -> Int
    func RunPartTwo() -> Int
}

struct TestDay {
    var Day: Day
    var P1_Expected: Int
    var P2_Expected: Int
}
