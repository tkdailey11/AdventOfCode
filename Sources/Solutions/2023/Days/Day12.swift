import Foundation
import Tools

final class Day12Solver: DaySolver {
    let dayNumber: Int = 12

    let expectedPart1Result = 8180
    let expectedPart2Result = 620189727003627

    private var input: Input!

    private struct Input {
        var lines: [Line]
        var expanded: [Line]
    }
    
    private enum State: Hashable {
        case operational
        case damaged
        case unknown
    }
    
    private struct Line {
        var springs: [State]
        var groups: [Int]
    }
    
    private var cache: [String : Int] = [:]
    
    private struct MemoizationKey: Hashable {
        let key: Int

        init(springs: [State], groups: [Int], isEndingAGroup: Bool) {
            var hasher = Hasher()

            hasher.combine(springs)
            hasher.combine(groups)
            hasher.combine(isEndingAGroup)

            key = hasher.finalize()
        }
    }
    
    private typealias Memoization = [MemoizationKey: Int]
    
    private func numberOfValidArrangements(with springs: [State], groups: [Int], memoization: inout Memoization, isEndingAGroup: Bool = false) -> Int {

        let key = MemoizationKey(springs: springs, groups: groups, isEndingAGroup: isEndingAGroup)
        if let cached = memoization[key] {
            return cached
        }
        
        var result = 0

        defer {
            memoization[key] = result
        }
        
        guard let firstSpring = springs.first else {
            result = groups.isEmpty ? 1 : 0
            return result
        }
        
        guard let firstGroup = groups.first else {
            result = springs.contains(.damaged) ? 0 : 1
            return result
        }
        
        if firstSpring == .operational {
            let newSprings = springs.from(index: 1) ?? []
            result = numberOfValidArrangements(with: newSprings, groups: groups, memoization: &memoization)
            return result
        }
        
        if isEndingAGroup {
            guard firstSpring != .damaged else { return 0 }
            let newSprings = springs.from(index: 1) ?? []
            result = numberOfValidArrangements(with: newSprings, groups: groups, memoization: &memoization)
            
            return result
        }
        
        if firstGroup <= springs.count, !springs[0 ..< firstGroup].contains(.operational) {
            let newSprings = springs.from(index: firstGroup) ?? []
            let newGroups = groups.from(index: 1) ?? []
            result += numberOfValidArrangements(with: newSprings, groups: newGroups, memoization: &memoization, isEndingAGroup: true)
        }

        if firstSpring == .unknown {
            let newSprings = springs.from(index: 1) ?? []
            result += numberOfValidArrangements(with: newSprings, groups: groups, memoization: &memoization)
        }
        
        return result
    }
    
    func solvePart1() -> Int {
        var memoization: Memoization = .init(minimumCapacity: 1_000_000)
        return input.lines.map{ line in
            numberOfValidArrangements(with: line.springs, groups: line.groups, memoization: &memoization)
        }.reduce(0, +)
    }

    func solvePart2() -> Int {
        var memoization: Memoization = .init(minimumCapacity: 1_000_000)
        let counts = input.expanded.map{ line in
            numberOfValidArrangements(with: line.springs, groups: line.groups, memoization: &memoization)
        }
        return counts.reduce(0, +)
    }

    func parseInput(rawString: String) {
        let lines = rawString.allLines().map { line in
            let parts = line.components(separatedBy: " ")
            let springs: [State] = parts[0].map {
                            switch $0 {
                            case ".": .operational
                            case "#": .damaged
                            case "?": .unknown
                            default: preconditionFailure()
                            }
                        }
            let groups = parts[1].components(separatedBy: ",").compactMap{ Int($0) }
            
            return Line(springs: springs, groups: groups)
        }
        let expanded = lines.map{ line in
            var temp = line
            temp.springs.expandBy(multiplier: 5, joinedBy: [.unknown])
            temp.groups.expandBy(multiplier: 5)
            return temp
        }
        input = .init(lines: lines, expanded: expanded)
    }
}
