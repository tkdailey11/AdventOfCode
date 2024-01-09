import Foundation
import Tools
import SwiftGraph

final class Day25Solver: DaySolver {
    let dayNumber: Int = 25
    
    let useTestInput: Bool = false
    let expectedPart1TestResult = 0
    let expectedPart2TestResult = "Merry Christmas 🎄"
    
    let expectedPart1Result = 0
    let expectedPart2Result = "Merry Christmas 🎄"
    
    private var input: Input!
    
    private struct Input {
        var graph: UGraph<String>
    }
    
    func solvePart1() -> Int {
        return 0
    }
    
    func solvePart2() -> String {
        "Merry Christmas 🎄"
    }
    
    func parseInput(rawString: String) {
        var componentMap: [String: [String]] = [:]
        
        rawString.allLines().forEach{ line in
            let parts = line.components(separatedBy: CharacterSet(charactersIn: ":"))
            let source = parts[0]
            let destinations = parts[1].trimmingCharacters(in: CharacterSet(charactersIn: " ")).components(separatedBy: CharacterSet(charactersIn: " "))
            
            componentMap[source] = destinations
        }
        
        var vertices: Set<String> = []
        
        componentMap.forEach{key, value in
            vertices.insert(key)
            vertices = vertices.union(value)
        }
        
        var edges: Set<UGraph<String>.Edge<String>> = []
        componentMap.forEach{ key, value in
            value.forEach({edges.insert(.init(a: key, b: $0))})
        }
        
        input = .init(graph: .init(vertices: vertices, edges: edges))
    }
}
