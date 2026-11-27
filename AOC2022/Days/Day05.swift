import Foundation
import AOCTools

public class Day05: AOCDay {
    public var dayNum: Int = 5
    public var part1Expected: String? = "RNZLFZSJH"
    public var part2Expected: String? = "CNSFCGJSM"
    public var part1ExpectedSample: String? = "CMZ"
    public var part2ExpectedSample: String? = "MCD"
    
    var stacks: [[String]] = []
    var linkedLists: [DoublyLinkedList<String>] = []
    
    struct Instruction {
        var amount: Int
        var source: Int
        var target: Int
    }
    var instructions: [Instruction] = []

    public func parseInput() {
        let contents = AOCTools.getRawInputStringForDay(dayNum, in: Bundle.module).allLines(includeEmpty: true)
        var index = 0
        while index < contents[0].chunked(into: 3).count {
            stacks.append([])
            linkedLists.append(.init())
            index += 1
        }
        
        index = 0
        var instructionsIndex = 0
        while index < contents.count {
            let line = contents[index]
            if line.trimmingCharacters(in: .whitespaces).starts(with: #/\d/#) {
                instructionsIndex = index + 2
                index = contents.count
            } else {
                let components = line.chunked(into: 4)
                var i = 0
                components.forEach{ c in
                    let object = c.map{ String($0) }.joined(separator: "").replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "").trimmingCharacters(in: .whitespaces)
                    
                    if !object.isEmpty {
                        stacks[i].append(object)
                        linkedLists[i].append(object)
                    }
                    i += 1
                }
            }
            index += 1
        }
        
        while instructionsIndex < contents.count {
            let line = contents[instructionsIndex].replacingOccurrences(of: "move", with: "").replacingOccurrences(of: "from", with: "").replacingOccurrences(of: "to", with: "")
            let components = line.components(separatedBy: .whitespaces).filter{ $0.isNotEmpty }
            if components.count == 3 {
                instructions.append(Instruction(amount: Int(components[0]) ?? 0, source: Int(components[1]) ?? 0, target: Int(components[2]) ?? 0))
            }

            instructionsIndex += 1
        }
    }

    public func solvePart1() -> String {
        instructions.forEach { instruction in
            var count = 0
            while count < instruction.amount {
                stacks[instruction.target - 1].insert(stacks[instruction.source - 1].removeFirst(), at: 0)
                count += 1
            }
        }
        
        return stacks.reduce(into: "") { result, stack in
            result += stack.first ?? ""
        }
    }

    public func solvePart2() -> String {
        instructions.forEach { instruction in
            let source = instruction.source - 1
            let target = instruction.target - 1

            let moved = linkedLists[source].popFirst(instruction.amount)
            linkedLists[target].insert(contentsOf: .init(moved), at: 0)
        }
        
        return linkedLists.reduce(into: "") { result, list in
            result += list.first ?? ""
        }
    }
}
