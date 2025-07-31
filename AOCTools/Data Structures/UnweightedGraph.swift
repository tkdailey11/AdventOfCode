import Foundation
import SwiftGraph

public struct Edge<T: Hashable>: Equatable, Hashable {
    public static func == (lhs: Edge<T>, rhs: Edge<T>) -> Bool {
        if lhs.isDirectional != rhs.isDirectional {
            return false
        }
        
        if lhs.isDirectional {
            return lhs.a == rhs.a && lhs.b == rhs.b
        } else {
            return (lhs.a == rhs.a && lhs.b == rhs.b) || (lhs.a == rhs.b && lhs.b == rhs.a)
        }
    }
    
    public var a: T
    public var b: T
    public let isDirectional: Bool

    public init(a: T, b: T, isDirectional: Bool = false) {
        self.a = a
        self.b = b

        self.isDirectional = isDirectional
    }
}

public struct UGraph<T: Hashable & Equatable & Codable> {
    var vertices: Set<T>
    var edges: Set<Edge<T>>
    
    public var vertexList: [T] {
        self.vertices.map({$0})
    }
    
    public var edgeList: [Edge<T>] {
        self.edges.map({$0})
    }

    public var count: Int {
        vertices.count
    }

    public init(vertices: Set<T> = [], edges: Set<Edge<T>> = []) {
        self.vertices = vertices
        self.edges = edges
    }
    
    public mutating func addEdge(from: T, to: T, isDirected: Bool = false) {
        self.edges.insert(.init(a: from, b: to, isDirectional: isDirected))
    }
    
    public mutating func removeSelfEdges() {
        self.edges = self.edges.filter({$0.a != $0.b})
    }

    public func edges(from vertex: T) -> Set<Edge<T>> {
        self.edges.filter{$0.a == vertex || (!$0.isDirectional && $0.b == vertex)}
    }
    
    public func neighboringVertices(vertex: T) -> Set<T> {
        Set(edges(from: vertex).map({$0.a == vertex ? $0.b : $0.a}))
    }
    
    public func copy() -> UGraph<T> {
        .init(vertices: Set(self.vertices.map{$0}), edges: Set(self.edges.map{$0}))
    }
    
    public func withCollapsed(edge: Edge<T>, newVertex: T) -> UGraph<T> {
        var newVertices = self.vertices.filter({$0 != edge.a && $0 != edge.b})
        newVertices.insert(newVertex)
        
        let toRemove = edges(from: edge.a).union(edges(from: edge.b))
        let newEdges = self.edges.subtracting(toRemove)
        
        let neighbors = neighboringVertices(vertex: edge.a).union(neighboringVertices(vertex: edge.b)).subtracting([edge.a, edge.b])
        
        var g: UGraph<T> = .init(vertices: newVertices, edges: newEdges)
        neighbors.forEach{ n in
            g.addEdge(from: newVertex, to: n)
        }
        g.removeSelfEdges()
        
        return g
    }
    
    public func toSwiftGraph() -> UnweightedGraph<T> {
        let g = UnweightedGraph(vertices: self.vertices.map({$0}))
        self.edges.forEach({g.addEdge(from: $0.a, to: $0.b, directed: $0.isDirectional)})
        return g
    }
}
