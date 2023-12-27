import Foundation
import Tools
import SwiftGraph

final class Day25Solver: DaySolver {
    let dayNumber: Int = 25
    
    let expectedPart1Result = 0
    let expectedPart2Result = "Merry Christmas 🎄"
    
    private var input: Input!
    
    private struct Input {
        var graph: UGraph<String>
    }
    
    func solvePart1() -> Int {
//        var graph = input.graph.copy()
//        var count = 0
//        while graph.count != 2 {
        input.graph.printGraphViz()
        let g = input.graph.performCuts(cutList: [
            .init(newVertex:"TestNode1", edge: .init(a: "hfx", b: "pzl")),
            .init(newVertex:"TestNode2", edge: .init(a: "bvb", b: "cmg")),
            .init(newVertex:"TestNode3", edge: .init(a: "nvd", b: "jqt")),
        ], getNewVertex: {"TestNode\($0)"})
        
//            let cycles = graph.detectCycles()
//            var cycleLines: Set<String> = []
//            
//            cycles.forEach{ c in
//                for i in 0 ..< c.count - 1 {
//                    cycleLines.insert("\(c[i]) -> \(c[i+1]) [dir=none];")
//                }
//            }
            
//            print("digraph {")
//            cycleLines.forEach({print($0)})
//            print("}")
//            
//            print()
//            graph.printGraphViz()
//            count += 1
//        }
        
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

//extension UnweightedGraph {
//    public func withCollapsed(edge: UnweightedEdge, newVertex: V) -> UnweightedGraph {
//        let originalVertices = [self.vertices[edge.u], self.vertices[edge.v]]
//
//        var newVertices = self.vertices.filter({!originalVertices.contains($0)})
//        newVertices.append(newVertex)
//        
//        let newGraph = UnweightedGraph(vertices: newVertices)
//        newVertices.forEach{v in
//            if let eForV = self.edgesForVertex(v) {
//                eForV.forEach{ e in
//                    let v1 = self.vertexAtIndex(e.u)
//                    let v2 = self.vertexAtIndex(e.v)
//                    
//                    
//                    
//                    if v1 == v {
//                        if !newGraph.edgeExists(from: v, to: v2) {
//                            newGraph.addEdge(from: v, to: v2)
//                        }
//                    } else {
//                        if newGraph.edgeExists(from: v, to: v1) {
//                            newGraph.addEdge(from: v, to: v1)
//                        }
//                    }
//                }
//                
//            }
//        }
//        
//        print("===========================")
//        self.printGraphViz()
//        print("---------------------------")
//        newGraph.printGraphViz()
//        print("===========================")
//
//        return newGraph
//    }
//    
//    public func copy() -> UnweightedGraph {
//        let graph = UnweightedGraph(vertices: self.vertices)
//        self.edgeList().forEach({graph.addEdge($0, directed: false)})
//        return graph
//    }
//}

extension UnweightedGraph {
    public func printGraphViz() {
        print("digraph {")
        
        self.vertices.forEach({print("\($0);")})
        
        self.edgeList().forEach{ e in
            let v1 = self.vertices[e.u]
            let v2 = self.vertices[e.v]
            print("\(v1) -> \(v2) [dir=none];")
        }
        
        print("}")
    }
}

//extension UnweightedGraph {
//    public convenience init(from decoder: Decoder) throws {
//        print("")
//    }
//    
//    public func encode(to encoder: Encoder) throws {
//        print("")
//    }
//}
