//
//  day7tests.swift
//  AdventOfCode
//
//  Created by Tyler Dailey on 12/7/23.
//

import Foundation

var testDays: [TestDay] = [
    TestDay(Day: Day7(dayNum: 7, part1Test: true, part2Test: true), P1_Expected: 6440, P2_Expected: -1),
]

func RunTests() -> Void {
    for td in testDays {
        print("Running Test Day \(td.Day.DayNum):")
        let res1 = td.Day.RunPartOne()
        if res1 == td.P1_Expected {
            print("Part 1 Passed")
        } else {
            print("Part 1 FAILED: Expected \(td.P1_Expected), but got \(res1)")
        }
        
        let res2 = td.Day.RunPartTwo()
        if res2 == td.P2_Expected {
            print("Part 2 Passed")
        } else {
            print("Part 2 FAILED: Expected \(td.P2_Expected), but got \(res2)")
        }
        
        print("==========================")
    }
}
