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

let allYears = [
//    AOC2023.getyear(),
    AOC2024.getyear(),
]

struct CLIOptions {
    var year: Int?
    var day: Int?
}

func printUsageAndExit(_ message: String? = nil) -> Never {
    if let message {
        print("⛔️ \(message)")
    }
    print("""
    Usage: AdventOfCode [--year YYYY [--day N]]

      --year, -y   Only solve this year (default: all registered years)
      --day, -d    Only solve this day within --year (default: all days)
      --help, -h   Show this message
    """)
    exit(message == nil ? 0 : 1)
}

func parseArguments(_ arguments: [String]) -> CLIOptions {
    var options = CLIOptions()
    var index = 0

    while index < arguments.count {
        let argument = arguments[index]

        switch argument {
        case "--year", "-y":
            index += 1
            guard index < arguments.count, let year = Int(arguments[index]) else {
                printUsageAndExit("Missing or invalid value for \(argument)")
            }
            options.year = year
        case "--day", "-d":
            index += 1
            guard index < arguments.count, let day = Int(arguments[index]) else {
                printUsageAndExit("Missing or invalid value for \(argument)")
            }
            options.day = day
        case "--help", "-h":
            printUsageAndExit()
        default:
            printUsageAndExit("Unknown argument: \(argument)")
        }

        index += 1
    }

    if options.day != nil && options.year == nil {
        printUsageAndExit("--day requires --year")
    }

    return options
}

let options = parseArguments(Array(CommandLine.arguments.dropFirst()))

let yearsToRun: [AOCYear]
if let yearNum = options.year {
    yearsToRun = allYears.filter { $0.yearNum == yearNum }
    if yearsToRun.isEmpty {
        printUsageAndExit("No year \(yearNum) registered.")
    }
} else {
    yearsToRun = allYears
}

for year in yearsToRun {
    print("Solving Year \(year.yearNum)")
    year.solveDays(dayNum: options.day)
}
