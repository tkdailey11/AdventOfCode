//
//  main.swift
//  AdventOfCode
//
//  Created by Tyler Dailey on 12/7/23.
//

import Foundation

var days: [Day] = [
    Day7(dayNum: 7, part1Test: false, part2Test: false),
]

for day in days {
    print("Running Day \(day.DayNum):")
    day.RunDay()
    print("==========================")
}

//RunTests()
