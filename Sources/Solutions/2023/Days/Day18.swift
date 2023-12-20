import Foundation
import Tools

final class Day18Solver: DaySolver {
    let dayNumber: Int = 18

    let expectedPart1Result = 48400
    let expectedPart2Result = 72811019847283
    
    private struct Instruction {
        var direction: Direction
        var steps: Int
        var hex: String
        
        init(parts: [String]) {
            self.direction = .northWest
            self.steps = Int(parts[1]) ?? 0
            self.hex = parts[2].trimmingCharacters(in: CharacterSet(charactersIn: "()#"))
            
            self.direction = getDirection(from: parts[0])
        }
        
        mutating func updateUsingHex() {
            let first = String(self.hex.dropLast())
            let last = String(self.hex.dropFirst(5))
            
            self.direction = getDirection(from: last)
            if let newSteps = Int(first, radix: 16) {
                self.steps = newSteps
            }
        }
        
        private func getDirection(from string: String) -> Direction {
            switch string {
            case "U", "3": .north
            case "D", "1": .south
            case "L", "2": .west
            case "R", "0": .east
            default: preconditionFailure()
            }
        }
    }

    private var input: Input!

    private struct Input {
        var instructions: [Instruction]
    }
    
    

    func solvePart1() -> Int {
        var start = Point2D(x: 0, y: 0)
        var points: [Point2D] = [start]
        
        input.instructions.forEach{ instruction in
            start = start.moved(to: instruction.direction, steps: instruction.steps)
            points.append(start)
        }
        
        return Shoelace.calculateArea(of: points)
    }

    func solvePart2() -> Int {
        var start = Point2D(x: 0, y: 0)
        var points: [Point2D] = [start]
        
        input.instructions.forEach{ instruction in
            var updated = instruction
            updated.updateUsingHex()
            start = start.moved(to: updated.direction, steps: updated.steps)
            points.append(start)
        }
        
        return Shoelace.calculateArea(of: points)
    }

    func parseInput(rawString: String) {
        let instructions = rawString.allLines().map{ line in
            Instruction(parts: line.components(separatedBy: " "))
        }
        input = .init(instructions: instructions)
    }
}
