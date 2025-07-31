//
//  Int+Bitwise.swift
//  
//
//  Created by Tyler Dailey on 12/13/23.
//

import Foundation

public extension Int {
    func withFlipped(bit: Int) -> Int {
        let other = 1 << bit
        return self ^ other
    }
    
    var bitCount: Int {
        self <= 0 ? 1 : Int(log2(Double(self))) + 1
    }
}
