//
//  UGraph+Algorithms.swift
//
//
//  Created by Tyler Dailey on 12/27/23.
//

import Foundation
internal import Collections

public extension UGraph {
    fileprivate struct FloodFillNode {
        var vertex: T
    }
    
    func getSubGraphs() -> [Set<T>] {
        var graphs: [Set<T>] = []
        var visited: Set<T> = []

        while visited.count < self.vertices.count {
            guard let first = self.vertices.first(where: {!visited.contains($0)}) else {
                break
            }
            var currentGraph = Set<T>([first])
            var toVisit: Deque<T> = Deque([first])
            
            while let current = toVisit.popFirst() {
                visited.insert(current)
                currentGraph.insert(current)
                toVisit.append(contentsOf: neighboringVertices(vertex: current).subtracting(visited))
            }
            
            graphs.append(currentGraph)
        }
        
        return graphs
    }
}

public extension UGraph {
    func karger(getNewVertex: ((Edge<T>) -> T)? = nil, cutList: [Edge<T>] = []) -> (UGraph<T>, Set<Edge<T>>) {
        guard let getVertex = getNewVertex else {
            return (.init(), .init())
        }
        
        var res = self.copy()
        var edgesCut: Set<Edge<T>> = []
        
        if cutList.isNotEmpty {
            cutList.enumerated().forEach{index, edge in
                res = res.withCollapsed(edge: edge, newVertex: getVertex(edge))
            }
        } else {
            while res.count > 2 {
                edgesCut.removeAll()
                guard let edge = res.edges.randomElement() else {
                    return (res, .init())
                }
                edgesCut.insert(edge)
                res = res.withCollapsed(edge: edge, newVertex: getVertex(edge))
                if res.count < 2 {
                    break
                }
            }
        }
        
        return (res, edgesCut)
    }
}
