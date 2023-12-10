import Foundation
import Tools

final class Day08Solver: DaySolver {
	let dayNumber: Int = 8

    let expectedPart1Result = 14681
    let expectedPart2Result = 14321394058031

    private var input: Input!

    private struct Input {
        let instructions: [Instruction]
        let nodes: [String: LeftRight]
    }

    private enum Instruction {
        case left
        case right

        init(string: String) {
            switch string {
            case "L": self = .left
            case "R": self = .right
            default: preconditionFailure()
            }
        }
    }

    private struct LeftRight {
        let left: String
        let right: String
    }

    func solvePart1() -> Int {
        var currIdx = 0
        var steps = 0
        var currLabel = "AAA"

        while currLabel != "ZZZ" {
            defer {
                currIdx = (currIdx + 1) % input.instructions.count
                steps += 1
            }

            let leftRight = input.nodes[currLabel]!

            switch input.instructions[currIdx] {
            case .left: currLabel = leftRight.left
            case .right: currLabel = leftRight.right
            }
        }

        return steps
    }

    func solvePart2() -> Int {
        var nodes: [String] = input.nodes.keys.filter { $0.hasSuffix("A") }
        
        let counts = nodes.map {
            var currLabel = $0
            var currIdx = 0
            var steps = 0
            
            while !currLabel.hasSuffix("Z") {
                defer {
                    currIdx = (currIdx + 1) % input.instructions.count
                    steps += 1
                }

                let leftRight = input.nodes[currLabel]!

                switch input.instructions[currIdx] {
                case .left: currLabel = leftRight.left
                case .right: currLabel = leftRight.right
                }
            }
            
            return steps
        }
        
        return Math.leastCommonMultiple(for: counts)
    }

    func parseInput(rawString: String) {
        let lines = rawString.allLines()
        var nodes: [String: LeftRight] = [:]

        let instructions: [Instruction] = lines[0].map { Instruction(string: String($0)) }

        for line in lines[1 ..< lines.count] {
            let values = line.getCapturedValues(pattern: #"([0-9A-Z]*) = \(([0-9A-Z]*), ([0-9A-Z]*)\)"#)!

            nodes[values[0]] = .init(left: values[1], right: values[2])
        }

        input = .init(instructions: instructions, nodes: nodes)
    }
}
