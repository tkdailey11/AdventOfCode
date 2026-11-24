import Foundation
import AOCTools

public class Day02: AOCDay {
    public var dayNum: Int = 2
    public var part1Expected: Int? = 11386
    public var part2Expected: Int? = 13600
    
    enum RPS: Int {
        case rock = 1
        case paper = 2
        case scissors = 3
        case unknown = 0
        
        init(_ str: String) {
            switch str.lowercased() {
            case "a", "x":
                self = .rock
            case "b", "y":
                self = .paper
            case "c", "z":
                self = .scissors
            default:
                self = .unknown
            }
        }
    }
    
    enum Winner: Int {
        case opponent = 0
        case player = 6
        case draw = 3
        case err = -1
    }
    
    struct GameRound {
        var opponent: RPS
        var player: RPS
        var desired: Winner
        
        init(opponent: RPS, player: RPS, desired: Winner) {
            self.opponent = opponent
            self.player = player
            self.desired = desired
        }
        
        init(_ str: String) {
            var desired: Winner = .err
            let components = str.components(separatedBy: .whitespaces)
            guard components.count == 2 else {
                self.init(opponent: .unknown, player: .unknown, desired: .err)
                return
            }
            
            let first: RPS = .init(components[0])
            let second: RPS = .init(components[1])
            
            switch second {
            case .rock:
                desired = .opponent
            case .paper:
                desired = .draw
            case .scissors:
                desired = .player
            case .unknown:
                desired = .err
            }
            
            self.init(opponent: first, player: second, desired: desired)
        }
        
        var outcome: Winner {
            if opponent == player {
                return .draw
            }
            
            switch opponent {
            case .rock:
                if player == .paper {
                    return .player
                }
            case .paper:
                if player == .scissors {
                    return .player
                }
            case .scissors:
                if player == .rock {
                    return .player
                }
            case .unknown:
                return .err
            }
            
            return .opponent
        }
        
        var score: Int {
            // The score for a single round is the score for the shape you selected (1 for Rock, 2 for Paper, and 3 for Scissors) plus the score for the outcome of the round (0 if you lost, 3 if the round was a draw, and 6 if you won).        }
            self.player.rawValue + self.outcome.rawValue
        }
        
        var scoreDesired: Int {
            let sum = self.desired.rawValue
            
            switch self.desired {
            case .opponent:
                switch self.opponent {
                case .rock:
                    return sum + RPS.scissors.rawValue
                case .paper:
                    return sum + RPS.rock.rawValue
                case .scissors:
                    return sum + RPS.paper.rawValue
                default:
                    return sum + RPS.unknown.rawValue
                }
            case .player:
                switch self.opponent {
                case .rock:
                    return sum + RPS.paper.rawValue
                case .paper:
                    return sum + RPS.scissors.rawValue
                case .scissors:
                    return sum + RPS.rock.rawValue
                default:
                    return sum + RPS.unknown.rawValue
                }
            case .draw:
                return sum + self.opponent.rawValue
            default:
                return sum + RPS.unknown.rawValue
            }
        }
    }
    
    var game: [GameRound] = []

    public func parseInput() {
        let contents = AOCTools.getRawInputStringForDay(dayNum, in: Bundle.module).allLines()
        
        contents.forEach{ line in
            game.append(.init(line))
        }
    }

    public func solvePart1() -> Int {
        game.reduce(0){ sum, round in
            sum + round.score
        }
    }

    public func solvePart2() -> Int {
        game.reduce(0){ sum, round in
            sum + round.scoreDesired
        }
    }
}
