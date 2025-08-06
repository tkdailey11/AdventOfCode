//
//  Array+Histogram.swift
//  AOCTools
//
//  Created by Tyler Dailey on 8/5/25.
//

import Foundation

public extension Array where Element == Int {
    var histogram: [Int: Int] {
        return self.reduce(into: [:]) { counts, number in
            counts[number, default: 0] += 1
        }
    }
}
