//
//  Array+ToolsTest.swift
//  
//
//  Created by Tyler Dailey on 12/12/23.
//

import Foundation
import Tools
import XCTest

final class ArrayExtensionsTests: XCTestCase {
    func testFromIndex() {
        let a = [1, 2, 3, 4]
        guard let b = a.from(index: 3) else {
            XCTFail("Unexpected index out of bounds")
            return
        }
        
        XCTAssertEqual(a.count, 4)
        XCTAssertEqual(b.count, 1)
    }
    
    func testExpandBy() {
        var a = [1, 2]
        a.expandBy(multiplier: 2)
        
        XCTAssertEqual(a.count, 4)
        
        var b = [1,2]
        let origCount = b.count
        let join = [0,0]
        b.expandBy(multiplier: 3, joinedBy: join)
        XCTAssertEqual(b.count, origCount * 3 + join.count * 2)
    }
    
    func testWithValueReplacedAt() {
        let a = [1, 2, 3]
        let b = a.withValueReplacedAt(index: 1, newElement: 0)
        
        XCTAssert(a.elementsEqual([1, 2, 3]))
        XCTAssert(b.elementsEqual([1, 0, 3]))
    }
}
