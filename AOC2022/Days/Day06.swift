import Foundation
import AOCTools

public class Day06: AOCDay {
    public var dayNum: Int = 6
    public var part1Expected: Int? = 1965
    public var part2Expected: Int? = 2773
    public var part1ExpectedSample: Int? = 10
    public var part2ExpectedSample: Int? = 19
    // SAMPLE PART 1
//    bvwbjplbgvbhsrlpgdmjqwftvncz: first marker after character 5
//    nppdvjthqldpwncqszvftbrmjlhg: first marker after character 6
//    nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg: first marker after character 10
//    zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw: first marker after character 11
    // SAMPLE PART 2
//    mjqjpqmgbljsphdztnvjfqwrcgsmlb: first marker after character 19
//    bvwbjplbgvbhsrlpgdmjqwftvncz: first marker after character 23
//    nppdvjthqldpwncqszvftbrmjlhg: first marker after character 23
//    nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg: first marker after character 29
//    zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw: first marker after character 26

    var line = ""
    
    public func parseInput() {
        let contents = AOCTools.getRawInputStringForDay(dayNum, in: Bundle.module).allLines()
        line = contents.first ?? ""
    }
    
    private func solve(for windowSize: Int) -> Int {
        let windows = line.windows(ofSize: windowSize)
        var i = 0
        while i < windows.count {
            if Set(windows[i]).count == windowSize {
                return i + windowSize
            }
            i += 1
        }
        
        return 0
    }

    public func solvePart1() -> Int {
       solve(for: 4)
    }

    public func solvePart2() -> Int {
        solve(for: 14)
    }
}
