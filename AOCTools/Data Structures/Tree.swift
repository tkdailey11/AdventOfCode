//
//  Tree.swift
//  AdventOfCode
//
//  Created by Tyler Dailey on 11/27/26.
//

internal import Collections

public class Tree<T>: CustomStringConvertible {
    public class TreeNode: CustomStringConvertible {
        public var value: T
        public private(set) var children: [TreeNode] = []   // public getter, private setter
        public private(set) weak var parent: TreeNode?
        
        public var isRoot: Bool { parent == nil }
        public var isLeaf: Bool { children.isEmpty }
        
        public init(_ value: T) {
            self.value = value
        }
        
        public func addChild(_ child: TreeNode) {
            child.parent = self
            children.append(child)
        }
        
        public func addChildWithValue(_ value: T) {
            addChild(TreeNode(value))
        }
        
        /// Folds this node's whole subtree into one value, bottom-up. `combine` is called once per
        /// node with that node's value and the results already computed for its children
        /// (in child order, empty for a leaf); the result for this node is what's returned.
        public func reduce<Result>(
            _ combine: (_ value: T, _ childResults: [Result]) throws -> Result
        ) rethrows -> Result {
            // Iterative post-order walk (no recursion, so deep trees can't overflow the stack).
            // Every finished subtree leaves exactly one entry in `results`, so when a node is
            // ready, its children's results are the last `children.count` entries, in order.
            var results: [Result] = []

            // `childrenDone` means the node's children have already been pushed and processed.
            var stack: [(node: TreeNode, childrenDone: Bool)] = [(self, false)]

            while let (node, childrenDone) = stack.popLast() {
                if childrenDone {
                    let childResults = Array(results.suffix(node.children.count))
                    results.removeLast(node.children.count)

                    results.append(try combine(node.value, childResults))
                } else {
                    stack.append((node, true))

                    for child in node.children.reversed() {
                        stack.append((child, false))
                    }
                }
            }

            return results.removeLast()
        }
        
        public var description: String {
            return "\(value)"
        }
    }
    
    public let root: TreeNode
    
    public init(_ rootValue: T) {
        self.root = TreeNode(rootValue)
    }
    
    /// Visits each node before its children, children left to right.
    public func forEachDepthFirstPreOrder(_ body: (TreeNode) throws -> ()) rethrows {
        var stack = [root]

        while let node = stack.popLast() {
            try body(node)

            // Pushed reversed so the first child is popped (visited) first.
            stack.append(contentsOf: node.children.reversed())
        }
    }

    /// Visits each node after all of its children, children left to right.
    public func forEachDepthFirstPostOrder(_ body: (TreeNode) throws -> ()) rethrows {
        // `true` means the node's children have already been pushed and visited.
        var stack: [(node: TreeNode, childrenDone: Bool)] = [(root, false)]

        while let (node, childrenDone) = stack.popLast() {
            if childrenDone {
                try body(node)
            } else {
                stack.append((node, true))

                for child in node.children.reversed() {
                    stack.append((child, false))
                }
            }
        }
    }

    /// Visits the root, then all nodes one level down, then the next level, and so on,
    /// children left to right within a level.
    public func forEachBreadthFirst(_ body: (TreeNode) throws -> ()) rethrows {
        // A Deque gives O(1) removal from the front; Array.removeFirst() is O(n).
        var queue: Deque<TreeNode> = [root]

        while let node = queue.popFirst() {
            try body(node)

            queue.append(contentsOf: node.children)
        }
    }
    
    /// An indented outline, one node per line, in the style of the AoC 2022 day 7 example:
    /// ```
    /// - /
    ///   - a
    ///     - e
    ///   - b
    /// ```
    public var description: String {
        let lines = root.reduce { value, childResults -> [String] in
            // This node's line, then every line from each child's subtree pushed one level in.
            ["- \(value)"] + childResults.flatMap { childLines in
                childLines.map { "  " + $0 }
            }
        }

        return lines.joined(separator: "\n")
    }
}
