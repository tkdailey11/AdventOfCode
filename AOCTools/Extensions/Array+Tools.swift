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
        for _ in 1 ..< multiplier {
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

public extension Collection {
    /// Splits into consecutive chunks of `size`; the last chunk may be shorter.
    /// Returns an empty array if `size` is not positive.
    func chunked(into size: Int) -> [[Element]] {
        guard size > 0 else {
            return []
        }

        var result: [[Element]] = []
        var start = startIndex

        while start != endIndex {
            let end = index(start, offsetBy: size, limitedBy: endIndex) ?? endIndex
            result.append(Array(self[start..<end]))
            start = end
        }

        return result
    }

    /// Every overlapping run of `size` consecutive elements, in order:
    /// `[1, 2, 3, 4].windows(ofSize: 2)` -> `[[1, 2], [2, 3], [3, 4]]`.
    /// Returns an empty array if `size` is not positive or is larger than the collection.
    func windows(ofSize size: Int) -> [[Element]] {
        guard size > 0 else {
            return []
        }

        var result: [[Element]] = []
        var start = startIndex

        while let end = index(start, offsetBy: size, limitedBy: endIndex) {
            result.append(Array(self[start..<end]))

            if end == endIndex {
                break
            }

            start = index(after: start)
        }

        return result
    }
}
