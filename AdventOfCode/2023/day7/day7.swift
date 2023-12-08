//
//  day7.swift
//  AdventOfCode
//
//  Created by Tyler Dailey on 12/7/23.
//

import Foundation

enum HandType: Int {
    case HighCard = 1
    case OnePair
    case TwoPair
    case ThreeKind
    case FullHouse
    case FourKind
    case FiveKind
}

struct Card {
    var Value: Int
    var Label: String
}

struct Hand {
    var Cards: [Card]
    var Bid: Int
    var HandType: HandType
}

func GetCardsFromString(_ input: String) -> [Card] {
    let cardStrings = input.split(separator: "").map{ String($0) }
    var res: [Card] = []
    
    for cs in cardStrings {
        var c: Card = Card(Value: 0, Label: cs)
        switch cs {
        case "2":
            c.Value = 1
            break
        case "3":
            c.Value = 2
            break
        case "4":
            c.Value = 3
            break
        case "5":
            c.Value = 4
            break
        case "6":
            c.Value = 5
            break
        case "7":
            c.Value = 6
            break
        case "8":
            c.Value = 7
            break
        case "9":
            c.Value = 8
            break
        case "T":
            c.Value = 9
            break
        case "J":
            c.Value = 10
            break
        case "Q":
            c.Value = 11
            break
        case "K":
            c.Value = 12
            break
        case "A":
            c.Value = 13
            break
        default:
            c.Value = 0
        }
        
        res.append(c)
    }
    
    return res
}

func GetCardsFromStringPartTwo(_ input: String) -> [Card] {
    let cardStrings = input.split(separator: "").map{ String($0) }
    var res: [Card] = []
    
    for cs in cardStrings {
        var c: Card = Card(Value: 0, Label: cs)
        switch cs {
        case "2":
            c.Value = 1
            break
        case "3":
            c.Value = 2
            break
        case "4":
            c.Value = 3
            break
        case "5":
            c.Value = 4
            break
        case "6":
            c.Value = 5
            break
        case "7":
            c.Value = 6
            break
        case "8":
            c.Value = 7
            break
        case "9":
            c.Value = 8
            break
        case "T":
            c.Value = 9
            break
        case "Q":
            c.Value = 10
            break
        case "K":
            c.Value = 11
            break
        case "A":
            c.Value = 12
            break
        default:
            c.Value = 0
        }
        
        res.append(c)
    }
    
    return res
}

func GetHandTypeFromCards(_ cards: [Card]) -> HandType {
    var cardCounts: [String: Int] = [:]
    
    for card in cards {
        cardCounts[card.Label] = (cardCounts[card.Label] ?? 0) + 1
    }
    
    switch cardCounts.count {
    case 1:
        return HandType.FiveKind
    case 2:
        let count = cardCounts[cards[0].Label] ?? 0
        if count == 1 || count == 4 {
            return HandType.FourKind
        } else {
            return HandType.FullHouse
        }
    case 3:
        for c in cardCounts.values {
            if c == 3 {
                return HandType.ThreeKind
            }
        }
        return HandType.TwoPair
    case 4:
        return HandType.OnePair
    default:
        return HandType.HighCard
    }
}

func GetHandTypeFromCardsPartTwo(_ cards: [Card]) -> HandType {
    var cardCounts: [String: Int] = [:]
    var jokerCount = 0
    
    for card in cards {
        if card.Label == "J" {
            jokerCount += 1
        } else {
            cardCounts[card.Label] = (cardCounts[card.Label] ?? 0) + 1
        }
    }
    
    switch jokerCount {
    case 5:
        return HandType.FiveKind
    case 4:
        return HandType.FiveKind
    case 3:
        if cardCounts.count == 1 {
            return HandType.FiveKind
        } else {
            return HandType.FourKind
        }
    case 2:
        if cardCounts.count == 1 {
            return HandType.FiveKind
        } else if cardCounts.count == 2 {
            return HandType.FourKind
        }
        else {
            return HandType.ThreeKind
        }
    case 1:
        if cardCounts.count == 1 {
            return HandType.FiveKind
        } else if cardCounts.count == 2 {
            if cardCounts.values.contains(where: { $0 == 2 }) {
                return HandType.FullHouse
            } else {
                return HandType.FourKind
            }
        } else if cardCounts.count == 3 {
            return HandType.ThreeKind
        } else {
            return HandType.OnePair
        }
    default:
        switch cardCounts.count {
        case 1:
            return HandType.FiveKind
        case 2:
            if cardCounts.values.contains(where: { $0 == 1 || $0 == 4 }) {
                return HandType.FourKind
            } else {
                return HandType.FullHouse
            }
        case 3:
            if cardCounts.values.contains(where: { $0 == 3 }) {
                return HandType.ThreeKind
            } else {
                return HandType.TwoPair
            }
        case 4:
            return HandType.OnePair
        default:
            return HandType.HighCard
        }
    }
    
    switch cardCounts.count {
    case 1:
        return HandType.FiveKind
    case 2:
        let count = cardCounts[cards[0].Label] ?? 0
        if count == 1 || count == 4 {
            return HandType.FourKind
        } else {
            return HandType.FullHouse
        }
    case 3:
        for c in cardCounts.values {
            if c == 3 {
                return HandType.ThreeKind
            }
        }
        return HandType.TwoPair
    case 4:
        return HandType.OnePair
    default:
        return HandType.HighCard
    }
}

// Returns true if h1 > h2
func CompareHands(h1: Hand, h2: Hand) -> Bool {
    if h1.HandType.rawValue > h2.HandType.rawValue {
        return true
    } else if h1.HandType.rawValue < h2.HandType.rawValue {
        return false
    }
    
    // Compare cards
    for i in 0..<h1.Cards.count {
        if h1.Cards[i].Value > h2.Cards[i].Value {
            return true
        } else if h1.Cards[i].Value < h2.Cards[i].Value {
            return false
        }
    }
    
    return false
}

class Day7: Day {
    var DayNum: Int
    
    var Part1Test: Bool
    var Part2Test: Bool
    
    init(dayNum: Int, part1Test: Bool, part2Test: Bool) {
        DayNum = dayNum
        Part1Test = part1Test
        Part2Test = part2Test
    }
    
    internal func RunDay() -> Void {
        let p1 = RunPartOne()
        let p2 = RunPartTwo()
        
        print("Part 1: \(p1)")
        print("Part 2: \(p2)")
    }
    
    internal func RunPartOne() -> Int {
        var lines: [String] = []
        if(Part2Test) {
            lines = day7SampleLines
        } else {
            lines = day7InputLines
        }
        
        var hands: [Hand] = []
        
        for line in lines {
            let parts = line.split(separator: " ").map{ String($0) }
            let bid = Int(parts[1]) ?? 0
            let cards = GetCardsFromString(parts[0])
            
            hands.append(Hand(Cards: cards, Bid: bid, HandType: GetHandTypeFromCards(cards)))
        }
        
        hands.sort { !CompareHands(h1: $0, h2: $1) }
        
        var sum = 0
        for i in 0..<hands.count {
            sum += (i + 1) * hands[i].Bid
        }
        
        return sum
    }

    internal func RunPartTwo() -> Int {
        var lines: [String] = []
        if Part2Test {
            lines = day7SampleLines
        } else {
            lines = day7InputLines
        }
        
        var hands: [Hand] = []
        
        for line in lines {
            let parts = line.split(separator: " ").map{ String($0) }
            let bid = Int(parts[1]) ?? 0
            let cards = GetCardsFromStringPartTwo(parts[0])
            
            hands.append(Hand(Cards: cards, Bid: bid, HandType: GetHandTypeFromCardsPartTwo(cards)))
        }
        
        hands.sort { !CompareHands(h1: $0, h2: $1) }
        
        var sum = 0
        for i in 0..<hands.count {
            sum += (i + 1) * hands[i].Bid
        }
        
        return sum
    }
}
