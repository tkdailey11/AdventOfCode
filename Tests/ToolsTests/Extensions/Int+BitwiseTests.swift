//
//  Int+BitwiseTests.swift
//  
//
//  Created by Tyler Dailey on 12/13/23.
//

import Foundation
import Tools
import XCTest

final class IntExtensionsTests: XCTestCase {
    func testBitCount() {
        let a = 0
        XCTAssertEqual(a.bitCount, 1)
        
        let b = 3
        XCTAssertEqual(b.bitCount, 2)
        
        let c = 127
        XCTAssertEqual(c.bitCount, 7)
        
        let d = 256
        XCTAssertEqual(d.bitCount, 9)
    }
    
    func testWithFlippedBit() {
        let a = 3
        
        // 11 -> 10
        let a1 = a.withFlipped(bit: 0)
        XCTAssertEqual(a1, 2)
        
        // 11 -> 01
        let a2 = a.withFlipped(bit: 1)
        XCTAssertEqual(a2, 1)
        
        let b = 63
        
        // 111111 -> 011111
        let b1 = b.withFlipped(bit: 5)
        XCTAssertEqual(b1, 31)
        
        // 111111 -> 101111
        let b2 = b.withFlipped(bit: 4)
        XCTAssertEqual(b2, 47)
    }
}
