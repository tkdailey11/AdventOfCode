import Foundation
import AOCTools

public class Day05: AOCDay {
    public var dayNum: Int = 5
    public var part1Expected: String? = nil
    public var part2Expected: String? = nil
    public var part1ExpectedSample: String? = "CMZ"
    public var part2ExpectedSample: String? = nil
    
    var stacks: [[String]] = []
    
    struct Instruction {
        var amount: Int
        var source: Int
        var target: Int
    }
    var instructions: [Instruction] = []

    public func parseInput() {
        let contents = AOCTools.getRawInputStringForDay(dayNum, in: Bundle.module).allLines(includeEmpty: true)
        var index = 0
        while index < contents[0].count {
            stacks.append([])
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
        ""
    }

    public func solvePart2() -> String {
        ""
    }
}
