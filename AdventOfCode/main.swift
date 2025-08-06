//
//  main.swift
//  AdventOfCode
//
//  Created by Tyler Dailey on 7/31/25.
//

import Foundation
import AOCTools
//import AOC2023
import AOC2024

let years = [
//    AOC2023.getyear(),
    AOC2024.getyear(),
]

for year in years {
    print("Solving Year \(year.yearNum)")
    year.solveDays()
}
