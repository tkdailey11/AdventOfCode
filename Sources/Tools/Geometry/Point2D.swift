import Foundation

public struct LabeledPoint2D {
    public var point: Point2D
    public var direction: Direction
}

public struct Point2D: Hashable, Equatable, Codable {
    public enum Degrees: Int {
        case zero = 0
        case ninety = 90
        case oneEighty = 180
        case twoSeventy = 270
        case threeSixty = 360

        public init?(rawValue: Int) {
            var degrees = rawValue % 360

            if degrees < 0 {
                degrees = 360 + degrees
            }

            switch degrees {
            case 0,
                 360: self = .zero
            case 90: self = .ninety
            case 180: self = .oneEighty
            case 270: self = .twoSeventy
            default: return nil
            }
        }
    }

    public var x: Int = 0
    public var y: Int = 0

    public static var zero: Point2D {
        .init(x: 0, y: 0)
    }

    public init() {}

    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }

    public init(commaSeparatedString: String) {
        let components = commaSeparatedString.components(separatedBy: ",")

        x = Int(components[0])!
        y = Int(components[1])!
    }

    public func turned(degrees: Degrees) -> Point2D {
        switch degrees {
        case .zero,
             .threeSixty: self
        case .ninety: .init(x: y, y: -x)
        case .oneEighty: .init(x: -x, y: -y)
        case .twoSeventy: .init(x: -y, y: x)
        }
    }

    public func moved(to direction: Direction, steps: Int = 1) -> Point2D {
        switch direction {
        case .north: self + .init(x: 0, y: -steps)
        case .south: self + .init(x: 0, y: steps)
        case .east: self + .init(x: steps, y: 0)
        case .west: self + .init(x: -steps, y: 0)
        case .northWest: self + .init(x: -steps, y: -steps)
        case .northEast: self + .init(x: steps, y: -steps)
        case .southWest: self + .init(x: -steps, y: steps)
        case .southEast: self + .init(x: steps, y: steps)
        }
    }

    public func neighbors(includingDiagonals: Bool = false) -> [Point2D] {
        if includingDiagonals {
            [
                moved(to: .north),
                moved(to: .east),
                moved(to: .south),
                moved(to: .west),
                moved(to: .northWest),
                moved(to: .northEast),
                moved(to: .southWest),
                moved(to: .southEast),
            ]
        } else {
            [
                moved(to: .north),
                moved(to: .east),
                moved(to: .south),
                moved(to: .west),
            ]
        }
    }
    
    public func labeledNeighbors(includingDiagonals: Bool = false) -> [LabeledPoint2D] {
        if includingDiagonals {
            [
                LabeledPoint2D(point: moved(to: .north), direction: .north),
                LabeledPoint2D(point: moved(to: .east),direction: .east),
                LabeledPoint2D(point: moved(to: .south),direction: .south),
                LabeledPoint2D(point: moved(to: .west),direction: .west),
                LabeledPoint2D(point: moved(to: .northWest),direction: .northWest),
                LabeledPoint2D(point: moved(to: .northEast),direction: .northEast),
                LabeledPoint2D(point: moved(to: .southWest),direction: .southWest),
                LabeledPoint2D(point: moved(to: .southEast),direction: .southEast),
            ]
        } else {
            [
                LabeledPoint2D(point: moved(to: .north), direction: .north),
                LabeledPoint2D(point: moved(to: .east),direction: .east),
                LabeledPoint2D(point: moved(to: .south),direction: .south),
                LabeledPoint2D(point: moved(to: .west),direction: .west),
            ]
        }
    }

    public func manhattanDistance(from rhs: Point2D) -> Int {
        let difference = rhs - self

        return abs(difference.x) + abs(difference.y)
    }

    public static func + (lhs: Point2D, rhs: Point2D) -> Point2D {
        .init(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    public static func - (lhs: Point2D, rhs: Point2D) -> Point2D {
        .init(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    public static func * (lhs: Point2D, rhs: Point2D) -> Point2D {
        .init(x: lhs.x * rhs.x, y: lhs.y * rhs.y)
    }

    public static func += (lhs: inout Point2D, rhs: Point2D) {
        lhs.x += rhs.x
        lhs.y += rhs.y
    }

    public static func -= (lhs: inout Point2D, rhs: Point2D) {
        lhs.x -= rhs.x
        lhs.y -= rhs.y
    }

    public static func *= (lhs: inout Point2D, rhs: Point2D) {
        lhs.x *= rhs.x
        lhs.y *= rhs.y
    }
}

// MARK: - CustomStringConvertible

extension Point2D: CustomStringConvertible {
    public var description: String {
        "(\(x), \(y))"
    }
}
