//
//  AOCYear.swift
//  AdventOfCode
//
//  Created by Tyler Dailey on 7/31/25.
//

public struct AOCYear {
    public var yearNum: Int
    var days: [any AOCDay]
    
    public init(yearNum: Int, days: [any AOCDay]) {
        self.yearNum = yearNum
        self.days = days
    }
    
    public func solveDays(dayNum: Int? = nil) {
        guard let dayNum else {
            for day in days {
                day.solveDay()
            }
            return
        }

        guard let day = days.first(where: { $0.dayNum == dayNum }) else {
            print(" -> ⛔️ No day \(dayNum) registered for year \(yearNum).")
            return
        }

        day.solveDay()
    }
}
