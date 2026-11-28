import Foundation
import AOCTools

public class Day07: AOCDay {
    public var dayNum: Int = 7
    public var part1Expected: Int? = 1543140
    public var part2Expected: Int? = 1117448
    public var part1ExpectedSample: Int? = 95437
    public var part2ExpectedSample: Int? = 24933642
    
    struct Day7Node: CustomStringConvertible {
        var name: String
        var isDirectory: Bool
        var size: Int?
        
        public var description: String {
            "\(name) - \(String(size ?? Int.min))"
        }
    }
    
    func updateSizes(tree: Tree<Day7Node>) {
        tree.forEachDepthFirstPostOrder { node in
            if node.value.size == nil {
                node.value.size = node.children.reduce(0) { sum, n in
                    sum + (n.value.size ?? 0)
                }
            }
        }
    }
    
    let tree: Tree<Day7Node> = Tree(Day7Node(name: "/", isDirectory: true))

    public func parseInput() {
        var contents = AOCTools.getRawInputStringForDay(dayNum, in: Bundle.module).allLines()
        contents.removeFirst(2)
        
        var currNode = tree.root
        contents.forEach { line in
            let parts = line.split(separator: " ")
            if parts[0] == "$" {
                if parts[1] == "cd" {
                    if parts[2] == ".." {
                        currNode = currNode.parent!
                    } else {
                        currNode = currNode.children.first(where: { $0.value.name == String(parts[2]) }) ?? tree.root
                    }
                }
            } else if parts[0] == "dir" {
                currNode.addChildWithValue(Day7Node(name: String(parts[1]), isDirectory: true))
            } else {
                let size = Int(parts[0]) ?? 0
                let name = String(parts[1])
                currNode.addChildWithValue(Day7Node(name: name, isDirectory: false, size: size))
            }
        }
        
        updateSizes(tree: tree)
    }

    public func solvePart1() -> Int {
        var sum = 0
        tree.forEachBreadthFirst { node in
            if let size = node.value.size, size <= 100_000 && node.value.isDirectory == true {
                sum += size
            }
        }
        return sum
    }

    public func solvePart2() -> Int {
        let totalSpace: Int = 70_000_000
        let reqSpace: Int = 30_000_000
        let remainingSpace = totalSpace - (tree.root.value.size ?? 0)
        let target = reqSpace - remainingSpace
        
        var smallestSize = tree.root.value.size ?? Int.max
        tree.forEachBreadthFirst { node in
            if let size = node.value.size, size >= target && size < smallestSize && node.value.isDirectory {
                smallestSize = node.value.size ?? smallestSize
            }
        }
        
        return smallestSize
    }
}
