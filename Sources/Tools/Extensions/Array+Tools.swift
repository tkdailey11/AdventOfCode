import Foundation

public extension Array {
    init(reservedCapacity: Int) {
        self.init()

        reserveCapacity(reservedCapacity)
    }
}

public extension Array {
    @inlinable func count(_ isIncluded: (Element) throws -> Bool) rethrows -> Int {
        try filter(isIncluded).count
    }

    subscript(safe index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }

        return self[index]
    }
}

public extension ArraySlice where Iterator.Element: Hashable {
    var mostCommonElement: Element? {
        guard isNotEmpty else {
            return nil
        }

        let uniqueElements = Set<Element>(self)

        var mostCommonElement: Element?
        var maxCount: Int?

        for element in uniqueElements {
            let count = filter { $0 == element }.count

            if maxCount == nil || count > maxCount! {
                mostCommonElement = element
                maxCount = count
            }
        }

        return mostCommonElement!
    }

    var leastCommonElement: Element? {
        guard isNotEmpty else {
            return nil
        }

        let uniqueElements = Set<Element>(self)

        var leastCommonElement: Element?
        var maxCount: Int?

        for element in uniqueElements {
            let count = filter { $0 == element }.count

            if maxCount == nil || count < maxCount! {
                leastCommonElement = element
                maxCount = count
            }
        }

        return leastCommonElement!
    }
}

public extension Array where Iterator.Element: Hashable {
    var mostCommonElement: Element? {
        ArraySlice(self).mostCommonElement
    }

    var leastCommonElement: Element? {
        ArraySlice(self).leastCommonElement
    }
}

public extension [Bool] {
    mutating func negate() {
        for index in 0 ..< count {
            self[index] = !self[index]
        }
    }

    func negated() -> [Bool] {
        var newArray: [Bool] = Array(repeating: false, count: count)

        for index in 0 ..< count {
            newArray[index] = !self[index]
        }

        return newArray
    }
}

public extension ArraySlice where Element == Bool {
    mutating func negate() {
        for index in 0 ..< count {
            self[index] = !self[index]
        }
    }

    func negated() -> [Bool] {
        var newArray: [Bool] = Array(repeating: false, count: count)

        for index in 0 ..< count {
            newArray[index] = !self[index]
        }

        return newArray
    }
}

public extension Array where Element: Comparable {
    static func < (_ lhs: [Element], _ rhs: [Element]) -> Bool {
        guard lhs.count == rhs.count else {
            preconditionFailure()
        }

        for items in zip(lhs, rhs) {
            if items.0 != items.1 {
                return items.0 < items.1
            }
        }

        return false
    }
}

public extension Array {
    func from(index: Int) -> Array<Element>? {
        if index > self.count - 1  || index < 0 {
            return nil
        }
        var temp: Array<Element> = Array.init(reservedCapacity: self.count - index)
        for i in index ..< self.count {
            temp.append(self[i])
        }
        return temp
    }
    
    mutating func expandBy(multiplier: Int, joinedBy: [Element] = []) {
        let elems = self
        for i in 1 ..< multiplier {
            self.append(contentsOf: joinedBy)
            self.append(contentsOf: elems)
        }
    }
    
    func withValueReplacedAt(index: Int, newElement: Element) -> [Element] {
        var n: [Element] = []
        self.enumerated().forEach{ i, v in
            if i == index {
                n.append(newElement)
            } else {
                n.append(self[i])
            }
        }
        return n
    }
}
