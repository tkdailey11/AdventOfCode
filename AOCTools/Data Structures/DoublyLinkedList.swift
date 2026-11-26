//
//  DoublyLinkedList.swift
//  AdventOfCode
//
//  Created by Tyler Dailey on 11/25/26.
//

public final class DoublyLinkedList<T>: CustomStringConvertible {
    private final class Node {
        var value: T

        var previous: Node?
        var next: Node?

        init(value: T) {
            self.value = value
        }

        init(value: T, previous: Node, next: Node) {
            self.value = value
            self.previous = previous
            self.next = next
        }
    }

    private var rootNode: Node?

    public private(set) var count = 0

    public var isEmpty: Bool {
        count == 0
    }

    public var first: T? {
        rootNode?.value
    }

    public var last: T? {
        rootNode?.previous?.value
    }

    public init(_ values: [T] = []) {
        for value in values {
            append(value)
        }
    }

    public func append(_ value: T) {
        if let rootNode {
            let previousNode = rootNode.previous!
            let nextNode = rootNode

            let newNode = Node(value: value, previous: previousNode, next: nextNode)

            previousNode.next = newNode
            nextNode.previous = newNode
        } else {
            let newNode = Node(value: value)

            newNode.previous = newNode
            newNode.next = newNode

            rootNode = newNode
        }

        count += 1
    }

    public func prepend(_ value: T) {
        // [0, 1, 2, 3] -> [4, 0, 1, 2, 3]

        append(value)

        // The new node is the last one in the ring; make it the root.
        rootNode = rootNode!.previous
    }

    /// Moves all of `other`'s elements onto the end of this list in O(1). `other` is left empty.
    public func concat(_ other: DoublyLinkedList<T>) {
        // [0, 1] concat [2, 3] -> [0, 1, 2, 3], other -> []

        precondition(other !== self, "Cannot concat a list with itself")

        guard let otherRoot = other.rootNode else {
            return
        }

        if let root = rootNode {
            let lastNode = root.previous!
            let otherLastNode = otherRoot.previous!

            lastNode.next = otherRoot
            otherRoot.previous = lastNode

            otherLastNode.next = root
            root.previous = otherLastNode
        } else {
            rootNode = otherRoot
        }

        count += other.count

        other.rootNode = nil
        other.count = 0
    }

    /// Inserts `value` so that it ends up at `index`, like `Array.insert(_:at:)`.
    /// `index` must be in `0 ... count`; `count` appends.
    public func insert(_ value: T, at index: Int) {
        // insert 9 at 2 [0, 1, 2, 3] -> [0, 1, 9, 2, 3]

        precondition(index >= 0 && index <= count, "Index out of range")

        if index == count {
            append(value)
        } else if index == 0 {
            prepend(value)
        } else {
            let nextNode = node(at: index)
            let previousNode = nextNode.previous!

            let newNode = Node(value: value, previous: previousNode, next: nextNode)

            previousNode.next = newNode
            nextNode.previous = newNode

            count += 1
        }
    }

    /// Moves all of `other`'s elements into this list so the first one ends up at `index`.
    /// `index` must be in `0 ... count`. Like `concat`, `other` is left empty.
    public func insert(contentsOf other: DoublyLinkedList<T>, at index: Int) {
        // insert [8, 9] at 2 into [0, 1, 2, 3] -> [0, 1, 8, 9, 2, 3]

        precondition(other !== self, "Cannot insert a list into itself")
        precondition(index >= 0 && index <= count, "Index out of range")

        guard let otherRoot = other.rootNode else {
            return
        }

        if index == count {
            concat(other)
            return
        }

        let nextNode = node(at: index)
        let previousNode = nextNode.previous!
        let otherLastNode = otherRoot.previous!

        previousNode.next = otherRoot
        otherRoot.previous = previousNode

        otherLastNode.next = nextNode
        nextNode.previous = otherLastNode

        if index == 0 {
            rootNode = otherRoot
        }

        count += other.count

        other.rootNode = nil
        other.count = 0
    }

    /// The node at `index`, walking from whichever end is closer. `index` must be in `0 ..< count`.
    private func node(at index: Int) -> Node {
        var currentNode = rootNode!

        if index <= count / 2 {
            for _ in 0 ..< index {
                currentNode = currentNode.next!
            }
        } else {
            for _ in 0 ..< count - index {
                currentNode = currentNode.previous!
            }
        }

        return currentNode
    }

    public func rotate(steps: Int) {
        guard let root = rootNode, count > 1 else {
            return
        }

        // Wrap around so we never walk more than half the ring.
        var steps = steps % count
        if steps > count / 2 {
            steps -= count
        } else if steps < -(count / 2) {
            steps += count
        }

        var currentNode = root

        if steps > 0 {
            // rotate 1 [0, 1, 2, 3] -> [3, 0, 1, 2]
            for _ in 0 ..< steps {
                currentNode = currentNode.previous!
            }
        } else if steps < 0 {
            // rotate -1 [0, 1, 2, 3] -> [1, 2, 3, 0]
            for _ in 0 ..< -steps {
                currentNode = currentNode.next!
            }
        }

        rootNode = currentNode
    }

    public func popLast() -> T? {
        // [0, 1, 2, 3] -> [0, 1, 2]

        guard let root = rootNode else {
            return nil
        }

        let lastNode = root.previous!

        if lastNode === root {
            rootNode = nil
        } else {
            let newLastNode = lastNode.previous!

            newLastNode.next = root
            root.previous = newLastNode
        }

        count -= 1

        return lastNode.value
    }

    public func popFirst() -> T? {
        // [0, 1, 2, 3] -> [1, 2, 3]

        guard let oldRoot = rootNode else {
            return nil
        }

        if oldRoot === oldRoot.next {
            rootNode = nil
        } else {
            let lastNode = oldRoot.previous!
            let newRoot = oldRoot.next!

            lastNode.next = newRoot
            newRoot.previous = lastNode

            rootNode = newRoot
        }

        count -= 1

        return oldRoot.value
    }

    public func popFirst(_ n: Int) -> [T] {
        var result: [T] = []

        for _ in 0 ..< max(n, 0) {
            guard let value = popFirst() else {
                break
            }

            result.append(value)
        }

        return result
    }

    public var description: String {
        guard let rootNode else {
            return "[]"
        }

        var result = "[\(rootNode.value)"

        var currentNode = rootNode.next!

        while currentNode !== rootNode {
            result += ", \(currentNode.value)"

            currentNode = currentNode.next!
        }

        return result + "]"
    }
}
