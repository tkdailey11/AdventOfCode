import Foundation
import Tools
import Collections

final class Day19Solver: DaySolver {
    let dayNumber: Int = 19

    // 382440
    let expectedPart1Result = 19114
    let expectedPart2Result = 167409079868000
    
    private func applyRulesTo(part: Part, rules: [Rule]) -> String? {
        for i in 0 ..< rules.count {
            let rule = rules[i]
            guard let condition = rule.condition else {
                return rule.targetName
            }
            
            guard let fieldName = rule.fieldName else {
                return nil
            }
            
            guard let expectedVal = rule.expectedVal else {
                return nil
            }
            
            if condition == .lt {
                switch fieldName {
                case "x":
                    if part.x < expectedVal {
                        return rule.targetName
                    }
                case "m":
                    if part.m < expectedVal {
                        return rule.targetName
                    }
                case "a":
                    if part.a < expectedVal {
                        return rule.targetName
                    }
                case "s":
                    if part.s < expectedVal {
                        return rule.targetName
                    }
                default:
                    return nil
                }
            } else {
                switch fieldName {
                case "x":
                    if part.x > expectedVal {
                        return rule.targetName
                    }
                case "m":
                    if part.m > expectedVal {
                        return rule.targetName
                    }
                case "a":
                    if part.a > expectedVal {
                        return rule.targetName
                    }
                case "s":
                    if part.s > expectedVal {
                        return rule.targetName
                    }
                default:
                    return nil
                }
            }
        }
        
        return nil
    }
    
    private struct Part {
        var x: Int
        var m: Int
        var a: Int
        var s: Int
    }
    
    private struct MaxMin {
        var max: Int
        var min: Int
    }
    
    private struct PartMaxMin {
        var x: MaxMin
        var m: MaxMin
        var a: MaxMin
        var s: MaxMin
    }
    
    private enum Condition: String {
        case lt = "<"
        case gt = ">"
    }
    
    private struct Rule {
        var fieldName: String?
        var condition: Condition?
        var expectedVal: Int?
        var targetName: String
    }
    
    private typealias Workflows = Dictionary<String, [Rule]>

    private var input: Input!

    private struct Input {
        var workflows: Workflows
        var parts: [Part]
    }

    func solvePart1() -> Int {
        var accepted: [Part] = []
        input.parts.forEach{ part in
            var current = "in"
            
            while current != "A" && current != "R" {
                current = applyRulesTo(part: part, rules: input.workflows[current] ?? []) ?? "R"
            }
            
            if current == "A" {
                accepted.append(part)
            }
        }
        
        return accepted.map({$0.x + $0.m + $0.a + $0.s}).reduce(0, +)
    }

    func solvePart2() -> Int {
        var stack = Deque<String>(["in"])
        var paths: [String] = ["in"]
        var conditionMap: Dictionary<String, [Rule]> = ["in": []]
        while let current = stack.popFirst() {
            let rules = input.workflows[current] ?? []
            let targets = rules.map({ $0.targetName })
            
            var newPaths: Set<String> = []
            paths.forEach{ path in
                if path.hasSuffix(current) {
                    targets.forEach{target in
                        let newPath = "\(path) -> \(target)"
                        newPaths.insert(newPath)
                        if let rule = rules.first(where: {$0.targetName == target}) {
                            guard let pathRules = conditionMap[path] else {
                                preconditionFailure()
                            }
                            conditionMap[newPath] = pathRules + [rule]
                        }
                    }
                }
            }
            paths.append(contentsOf: newPaths)
            
            stack.append(contentsOf: targets)
        }
        
        let acceptedPaths = paths.filter({$0.hasSuffix("A")})
        let acceptedSet: Set<String> = Set(acceptedPaths)
        conditionMap.keys.forEach{ key in
            if !acceptedSet.contains(key) {
                conditionMap.removeValue(forKey: key)
            }
        }
        
        var maxMins: PartMaxMin = PartMaxMin(
            x: MaxMin(max: 4000, min: 1),
            m: MaxMin(max: 4000, min: 1),
            a: MaxMin(max: 4000, min: 1),
            s: MaxMin(max: 4000, min: 1)
        )
        
        acceptedSet.forEach{ path in
            let rules = conditionMap[path] ?? []
            rules.forEach{ rule in
                if let expected = rule.expectedVal {
                    
                    if rule.condition == .gt {
                        switch rule.fieldName {
                        case "x":
                            if maxMins.x.min < expected {
                                maxMins.x.min = expected
                            }
                        case "m":
                            if maxMins.m.min < expected {
                                maxMins.m.min = expected
                            }
                        case "a":
                            if maxMins.a.min < expected {
                                maxMins.a.min = expected
                            }
                        case "s":
                            if maxMins.s.min < expected {
                                maxMins.s.min = expected
                            }
                        default: preconditionFailure()
                        }
                    } else {
                        switch rule.fieldName {
                        case "x":
                            if maxMins.x.max > expected {
                                maxMins.x.max = expected
                            }
                        case "m":
                            if maxMins.m.max > expected {
                                maxMins.m.max = expected
                            }
                        case "a":
                            if maxMins.a.max > expected {
                                maxMins.a.max = expected
                            }
                        case "s":
                            if maxMins.s.max > expected {
                                maxMins.s.max = expected
                            }
                        default: preconditionFailure()
                        }
                    }
                }
            }
        }
        
        return (maxMins.x.max - maxMins.x.min + 1) *
        (maxMins.m.max - maxMins.m.min + 1) *
        (maxMins.a.max - maxMins.a.min + 1) *
        (maxMins.s.max - maxMins.s.min + 1)
    }

    func parseInput(rawString: String) {
        var workflows: Workflows = [:]
        var parts: [Part] = []
        rawString.allLines(includeEmpty: true).forEach{ line in
            if !line.isEmpty && !line.hasPrefix("{"){
                let parts = line.trimmingCharacters(in: CharacterSet(charactersIn: "}")).components(separatedBy: CharacterSet(charactersIn: "{"))
                let name = parts[0]
                let rules = parts[1].components(separatedBy: CharacterSet(charactersIn: ",")).map{ str in
                    if str.contains(":") {
                        if str.contains(">") {
                            let strParts = str.components(separatedBy: CharacterSet(charactersIn: ">"))

                            let other = strParts[1].components(separatedBy: CharacterSet(charactersIn: ":"))
                            
                            return Rule(fieldName: strParts[0], condition: .gt, expectedVal: Int(other[0]), targetName: other[1])
                        } else {
                            let strParts = str.components(separatedBy: CharacterSet(charactersIn: "<"))

                            let other = strParts[1].components(separatedBy: CharacterSet(charactersIn: ":"))
                            
                            return Rule(fieldName: strParts[0], condition: .lt, expectedVal: Int(other[0]), targetName: other[1])
                        }
                    } else {
                        return Rule(targetName: str)
                    }
                }
                workflows[name] = rules
            } else if !line.isEmpty {
                var part = Part(x: 0, m: 0, a: 0, s: 0)
                line.trimmingCharacters(in: CharacterSet(charactersIn: "{}")).components(separatedBy: CharacterSet(charactersIn: ",")).forEach{ str in
                    let strs = str.components(separatedBy: CharacterSet(charactersIn: "="))
                    
                    switch strs[0] {
                    case "x":
                        part.x = Int(strs[1]) ?? 0
                    case "m":
                        part.m = Int(strs[1]) ?? 0
                    case "a":
                        part.a = Int(strs[1]) ?? 0
                    case "s":
                        part.s = Int(strs[1]) ?? 0
                    default:
                        preconditionFailure()
                    }
                }
                parts.append(part)
            }
        }
        input = .init(workflows: workflows, parts: parts)
    }
}
