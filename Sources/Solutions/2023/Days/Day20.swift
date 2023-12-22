import Foundation
import Tools
import Collections

final class Day20Solver: DaySolver {
    let dayNumber: Int = 20

    let expectedPart1Result = 834323022
    let expectedPart2Result = 0
    
    private enum ModuleType {
        case broadcast
        case flip_flop
        case conjunction
        
        init(from string: String) {
            if string == "broadcaster" {
                self = .broadcast
            } else if string.hasPrefix("%") {
                self = .flip_flop
            } else if string.hasPrefix("&") {
                self = .conjunction
            } else {
                preconditionFailure()
            }
        }
    }
    
    private struct Module {
        var label: String = "broadcaster"
        var type: ModuleType = .broadcast
        var destLabels: [String] = []
        var onOffState: Bool = false
        var inputPulse: [String:Bool] = [:]
    }
    
    private struct Signal {
        var from: String
        var isHigh: Bool = false
    }
    
    private var lowPulseCount = 0
    private var highPulseCount = 0
    
    private func receivePulse(src: String, dest: String, isHigh: Bool = false) -> Signal? {
//        print("\(src) -\(isHigh ? "high" : "low")-> \(dest)")
        if src == "button" {
            return Signal(from: dest, isHigh: isHigh)
        }
        
        guard let module = input.modules[dest] else {
            return nil
        }
        switch module.type {
        case .flip_flop:
            if !isHigh {
                if module.onOffState {
                    input.modules[dest]?.onOffState = false
                    return Signal(from: module.label)
                } else {
                    input.modules[dest]?.onOffState = true
                    return Signal(from: module.label, isHigh: true)
                }
            }
        case .conjunction:
            input.modules[dest]?.inputPulse[src] = isHigh
            let containsLow = input.modules[dest]?.inputPulse.contains(where: {!$0.value}) ?? true
            return Signal(from: module.label, isHigh: containsLow)
        case .broadcast:
            return Signal(from: module.label, isHigh: isHigh)
        }
        
        return nil
    }
    
    private func sendPulse(from src: String, isHigh: Bool = false) -> [Signal] {
        var results: [Signal] = []
        if let srcModule = input.modules[src] {
            srcModule.destLabels.forEach{ dest in
                if isHigh {
                    highPulseCount += 1
                } else {
                    lowPulseCount += 1
                }
                if let signal = receivePulse(src: src, dest: dest, isHigh: isHigh) {
                    results.append(signal)
                }
            }
        }
        return results
    }

    private var input: Input!

    private struct Input {
        var modules: [String:Module]
    }

    func solvePart1() -> Int {
        for _ in 0 ..< 1000 {
            guard let buttonPress = receivePulse(src: "button", dest: "broadcaster", isHigh: false) else {
                return -1
            }
            
            lowPulseCount += 1
            var signalQueue: Deque<Signal> = [buttonPress]
            
            while let signal = signalQueue.popFirst() {
                sendPulse(from: signal.from, isHigh: signal.isHigh).forEach({signalQueue.append($0)})
            }
        }
        
        return lowPulseCount * highPulseCount
    }

    func solvePart2() -> Int {
        0
    }

    func parseInput(rawString: String) {
        var dict: [String:Module] = [:]
        var conjunctionLabels: [String] = []
        rawString.allLines().forEach{ line in
            let parts = line.components(separatedBy: " -> ")
            var label = parts[0]
            let type = ModuleType(from: label)
            if type == .conjunction {
                conjunctionLabels.append(label.trimmingCharacters(in: CharacterSet(charactersIn: "&%")))
            }
            label = label.trimmingCharacters(in: CharacterSet(charactersIn: "&%"))
            var mod = Module(label: label, type: type, destLabels: parts[1].components(separatedBy: ", "))
            
            if type == .flip_flop {
                mod.onOffState = false
            }
            
            dict[label] = mod
        }
        
        conjunctionLabels.forEach{ label in
            dict.forEach{ key, val in
                if val.destLabels.contains(label) {
                    dict[label]?.inputPulse[key] = false
                }
            }
        }
        
        input = .init(modules: dict)
    }
}
