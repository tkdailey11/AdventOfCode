import Foundation
import Tools

final class Day13Solver: DaySolver {
    let dayNumber: Int = 13

    let expectedPart1Result = 37975
    let expectedPart2Result = 32497

    private var input: Input!

    private struct Input {
        var patterns: [Pattern]
    }
    
    private struct Reflections {
        var horizontal: Int
        var vertical: Int
    }
    
    private struct Pattern {
        var rows: [Int]
        var cols: [Int]
        var rowLength: Int
        var colLength: Int
    }
    
    private func isReflection(leftIndex: Int, rowCol: [Int]) -> Bool {
        var i = leftIndex
        var j = i + 1
        
        while i >= 0 && j < rowCol.count {
            if rowCol[i] != rowCol[j] {
                return false
            }
            
            i -= 1
            j += 1
        }
        
        return true
    }
    
    func findReflectionLine(_ lines: [Int]) -> Int? {
        for i in 0 ..< lines.count - 1 {
            if isReflection(leftIndex: i, rowCol: lines) {
                return i + 1
            }
        }
        return nil
    }
    
    private func findReflectionInPattern(pattern: Pattern) -> Reflections {
        let horiz = findReflectionLine(pattern.rows) ?? -1
        let vert = findReflectionLine(pattern.cols) ?? -1
        
        return Reflections(horizontal: horiz * 100, vertical: vert)
    }

    func solvePart1() -> Int {
        input.patterns.map{
            var reflections = findReflectionInPattern(pattern: $0)
            if reflections.horizontal > 0 {
                return reflections.horizontal
            } else if reflections.vertical > 0 {
                return reflections.vertical
            } else {
                return 0
            }
        }.reduce(0, +)
    }

    func solvePart2() -> Int {
        input.patterns.map{ pattern in
            let originalReflection = findReflectionInPattern(pattern: pattern)
            var originalReflectionLine = originalReflection.horizontal > 0 ? originalReflection.horizontal : originalReflection.vertical

            var currColBit = pattern.colLength - 1
            for i in 0 ..< pattern.rows.count {
                let row = pattern.rows[i]
                var currRowBit = pattern.rowLength - 1 - i
                
                var columnIndex = 0
                
                while columnIndex < pattern.rowLength - 1 {
                    let newRow = row.withFlipped(bit: currRowBit)
                    var newCol = pattern.cols[columnIndex]
                    if currColBit >= 0 {
                        newCol = pattern.cols[columnIndex].withFlipped(bit: currColBit)
                    }
                    
                    let newPattern = Pattern(
                        rows: pattern.rows.withValueReplacedAt(index: i, newElement: newRow),
                        cols: pattern.cols.withValueReplacedAt(index: columnIndex, newElement: newCol),
                        rowLength: pattern.rowLength,
                        colLength: pattern.colLength
                    )
                    
                    let newReflection = findReflectionInPattern(pattern: newPattern)
                    if (newReflection.horizontal > 0 || newReflection.vertical > 0) {
                        if newReflection.horizontal > 0 && newReflection.horizontal != originalReflectionLine {
                            return newReflection.horizontal
                        } else if newReflection.vertical > 0 && newReflection.vertical != originalReflectionLine {
                            return newReflection.vertical
                        }
                    }
                    
                    currRowBit -= 1
                    columnIndex += 1
                }
                
                currColBit -= 1
            }
            
            return originalReflectionLine
        }.reduce(0, +)
    }

    func parseInput(rawString: String) {
        var patterns: [Pattern] = []
        var rows: [String] = []
        var cols: [String] = []
        rawString.allLines(includeEmpty: true).forEach{ line in
            if line.isEmpty {
                let rowNums = rows.compactMap{ row in
                    row.replacingOccurrences(of: ".", with: "0")
                       .replacingOccurrences(of: "#", with: "1")
                }
                let colNums = cols.compactMap{ col in
                    col.replacingOccurrences(of: ".", with: "0")
                       .replacingOccurrences(of: "#", with: "1")
                }
                patterns.append(Pattern(rows: rowNums.compactMap{ Int($0, radix: 2) }, cols: colNums.compactMap{ Int($0, radix: 2) }, rowLength: rowNums[0].count, colLength: colNums[0].count))
                rows = []
                cols = []
            } else {
                rows.append(line)
                if cols.isEmpty {
                    for _ in 0 ..< line.count {
                        cols.append("")
                    }
                }
                line.map{ String($0) }.enumerated().forEach{ idx, c in
                    cols[idx] += c
                }
            }
        }
        input = .init(patterns: patterns)
    }
}
