//
//  Set+Pop.swift
//  AdventOfCode
//
//  Created by administrator on 11/20/26.
//

import Foundation

public extension Set where Element: Comparable {
    mutating func pop(max: Bool = true) -> Element? {
        if max {
            guard let max = self.max() else { return nil }
            self.remove(max)
            return max
        }
        guard let min = self.min() else { return nil }
        self.remove(min)
        return min
    }
}
