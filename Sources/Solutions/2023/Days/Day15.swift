import Foundation
import Tools

final class Day15Solver: DaySolver {
    let dayNumber: Int = 15

    let expectedPart1Result = 505427
    let expectedPart2Result = 0

    private var input: Input!

    private struct Input {
        var steps: [String]
    }
    
    enum LensAction: String {
        case add = "="
        case remove = "-"
        case none = "."

        init(string: String) {
            switch string {
            case "=": self = .add
            case "-": self = .remove
            default: self = .none
            }
        }
    }
    
    struct LensMap {
        var label: String
        var focalLength: Int
        var action: LensAction
        
        init(string: String) {
            if string.contains("=") {
                let parts = string.split(separator: "=")
                self.label = String(parts[0])
                self.focalLength = Int(parts[1]) ?? 0
                self.action = .add
            } else if string.contains("-") {
                let parts = string.split(separator: "-")
                self.label = String(parts[0])
                self.focalLength = 0
                self.action = .remove
            } else {
                self.label = string
                self.focalLength = 0
                self.action = .none
            }
        }
        
        var description: String { return "[\(label) \(focalLength)]" }
        
        func getHash() -> Int {
            var res = 0
            AsciiString(string: self.label).forEach{ c in
                res += Int(c)
                res *= 17
                res %= 256
            }
            
            return res
        }
    }
    
    func generateHash(for input: AsciiString) -> Int {
        var res = 0
        
        input.forEach{ c in
            res += Int(c)
            res *= 17
            res %= 256
        }
        
        return res
    }

    func solvePart1() -> Int {
        input.steps.map{ generateHash(for: AsciiString(string: $0)) }.reduce(0, +)
    }

    func solvePart2() -> Int {
        var res: [[LensMap]] = []
        let parsedSteps = input.steps.map{ LensMap(string: $0) }
        
        parsedSteps.forEach{ step in
            let hash = step.getHash()
            switch step.action {
            case .add:
                if res.count <= hash {
                    for _ in res.count ... hash {
                        res.append([])
                    }
                }
                var foundExisting = false
                for i in 0 ..< res[hash].count {
                    if res[hash][i].label == step.label {
                        res[hash][i].focalLength = step.focalLength
                        foundExisting = true
                        break
                    }
                }
                if !foundExisting {
                    res[hash].append(step)
                }
            case .remove:
                if res.count > hash {
                    let box = res[hash].filter{ $0.label != step.label }
                    res[hash] = box
                }
            case .none:
                break
            }
        }
        
        var sum = 0
        for boxNum in 0 ..< res.count {
            let box = res[boxNum]
            if box.isNotEmpty {
                sum += box.enumerated().map{ index, lens in
                    (boxNum + 1) * (index + 1) * lens.focalLength
                }.reduce(0, +)
            }
        }
        
        return sum
    }

    func parseInput(rawString: String) {
        input = .init(steps: rawString.allLines().flatMap(
            { $0.components(separatedBy: ",") }
        ))
    }
}
