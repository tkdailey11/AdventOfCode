//
//  DoublyLinkedList.swift
//  AdventOfCode
//
//  Created by Tyler Dailey on 11/25/26.
//

public final class DoublyLinkedList<T>: CustomStringConvertible {
    private final class Node<S> {
        var value: S

        var previous: Node?
        var next: Node?

        init(value: S) {
            self.value = value
        }

        init(value: S, previous: Node, next: Node) {
            self.value = value
            self.previous = previous
            self.next = next
        }
    }

    private var rootNode: Node<T>?

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
    }

    public func rotate(steps: Int) {
        guard rootNode != nil else {
            return
        }

        if steps > 0 {
            // rotate 1 [0, 1, 2, 3] -> [3, 0, 1, 2]
            var currentNode: Node = rootNode!

            for _ in 0 ..< steps {
                currentNode = currentNode.previous!
            }

            rootNode = currentNode
        } else if steps < 0 {
            // rotate 1 [0, 1, 2, 3] -> [1, 2, 3, 0]
            var currentNode: Node = rootNode!

            for _ in 0 ..< abs(steps) {
                currentNode = currentNode.next!
            }

            rootNode = currentNode
        }
    }

    public func popLast() -> T? {
        // [0, 1, 2, 3] -> [0, 1, 2]

        guard rootNode != nil else {
            return nil
        }

        let value = rootNode!.previous!.value

        if rootNode! === rootNode!.previous {
            rootNode = nil
        } else {
            rootNode!.previous!.previous!.next = rootNode
            rootNode!.previous = rootNode!.previous!.previous!
        }

        return value
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

        return oldRoot.value
    }

    public func popFirst(_ n: Int) -> [T] {
        guard rootNode != nil else {
            return []
        }
        
        var result: [T] = []
        
        for _ in 0 ..< n {
            if let val = popFirst() {
                result.append(val)
            }
        }
        
        return result
    }

    public var description: String {
        guard let rootNode else {
            return "[]"
        }

        var result = "["

        result += "\(rootNode.value)"

        var currentNode: Node = rootNode.next!

        while currentNode !== rootNode {
            result += ", " + "\(currentNode.value)"

            currentNode = currentNode.next!
        }

        return result + "]"
    }
}
