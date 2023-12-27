import Foundation

public struct UGraph<Element: Hashable> {
    public typealias ElementIndex = Int

    public struct Edge<T: Hashable>: Equatable, Hashable {
        public static func == (lhs: UGraph.Edge<T>, rhs: UGraph.Edge<T>) -> Bool {
            lhs.a == rhs.a && lhs.b == rhs.b && lhs.isDirectional == rhs.isDirectional
        }
        
        public let a: T
        public let b: T

        public var isDirectional: Bool

        public init(a: T, b: T, isDirectional: Bool = false) {
            self.a = a
            self.b = b

            self.isDirectional = isDirectional
        }
    }
    
    public struct EdgeCut<T: Hashable> {
        public var newVertex: T
        public var edge: Edge<T>
        
        public init(newVertex: T, edge: Edge<T>) {
            self.newVertex = newVertex
            self.edge = edge
        }
    }

    let vertices: Set<Element>
    let edges: Set<Edge<Element>>

    public init(vertices: Set<Element>, edges: Set<Edge<Element>>) {
        self.vertices = vertices
        self.edges = edges
    }

    public func edges(from vertex: Element) -> Set<Edge<Element>> {
        self.edges.filter{$0.a == vertex || (!$0.isDirectional && $0.b == vertex)}
    }

    public var count: Int {
        vertices.count
    }
    
    public func copy() -> UGraph<Element> {
        .init(vertices: Set(self.vertices.map{$0}), edges: Set(self.edges.map{$0}))
    }
    
    public func withCut(newVertex: Element, edgeToCut: Edge<Element>? = nil) -> UGraph? {
        guard let edge = edgeToCut ?? self.edges.randomElement() else {
            return nil
        }
        
//        let edgesToUpdate = self.edges(from: edge.a).union(self.edges(from: edge.b))
//        let newVertices = self.vertices.filter({$0 != edge.a && $0 != edge.b}).union([newVertex])
//        var newEdges = self.edges.subtracting(edgesToUpdate)
//        edgesToUpdate.forEach{e in
//            if e != edge {
//                if e.a == edge.a || e.a == edge.b {
//                    newEdges.insert(.init(a: newVertex, b: e.b, isDirectional: e.isDirectional))
//                } else {
//                    newEdges.insert(.init(a: e.a, b: newVertex, isDirectional: e.isDirectional))
//                }
//            }
//        }
        
        var toRemove = [edge]
        if !edge.isDirectional  {
            toRemove.append(.init(a: edge.b, b: edge.a))
        }
        
        return .init(vertices: self.vertices, edges: self.edges.subtracting(toRemove))
    }
    
    public func performCuts(cutList: [EdgeCut<Element>] = [], getNewVertex: (Int) -> Element) -> UGraph<Element> {
        var graph = self.copy()
        if cutList.isNotEmpty {
            cutList.forEach{ ec in
                if let n = graph.withCut(newVertex: ec.newVertex, edgeToCut: ec.edge) {
                    graph = n
                    n.printGraphViz()
                    print()
                }
            }
            
        } else {
            for i in 0 ..< 3 {
                if let n = graph.withCut(newVertex: getNewVertex(i)) {
                    graph = n
                }
            }
        }

        return graph
    }
    
    public func printGraphViz() {
        print("digraph {")
        
        self.vertices.forEach({print("\($0);")})
        
        self.edges.forEach{ e in
            if let v1 = self.vertices.first(where: {$0 == e.a}), let v2 = self.vertices.first(where: {$0 == e.b}) {
                print("\(v1) -> \(v2) [dir=none];")
            }
        }
        
        print("}")
    }
}
