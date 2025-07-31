//
//  UGraph+DOT.swift
//  
//
//  Created by Tyler Dailey on 12/27/23.
//

import Foundation

public extension UGraph {
    func encodeDOT() -> String {
        var sourceMap: [T:Set<T>] = [:]
        
        self.edges.forEach{ edge in
            if sourceMap.contains(where: {$0.key == edge.a}) {
                sourceMap[edge.a]?.insert(edge.b)
            } else {
                sourceMap[edge.a] = Set([edge.b])
            }
        }
        
        var lines: [String] = ["digraph {"]
        sourceMap.forEach{ key, value in
            let valString = value.map({String(describing: $0)}).joined(separator: " ")
            lines.append("\(key) -> {\(valString)} [dir=none];")
        }
        
        lines.append("}")
        
        return lines.joined(separator: "\n")
    }
}
