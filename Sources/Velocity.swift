//
//  Velocity.swift
//  Scale
//
//  Created by Khoa Pham
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation

public enum VelocityUnit: Double {
    case ms = 1
    case kmph = 3.6
    case mph = 2.23694
    
    static var defaultScale: Double {
        return VelocityUnit.ms.rawValue
    }
}

public struct Velocity {
    public let value: Double
    public let unit: VelocityUnit

    public init(value: Double, unit: VelocityUnit) {
        self.value = value
        self.unit = unit
    }

    public func to(unit unit: VelocityUnit) -> Velocity {
        return Velocity(value: self.value * self.unit.rawValue * VelocityUnit.ms.rawValue / unit.rawValue, unit: unit)
    }
}

public extension Double {
    public var ms: Velocity {
        return Velocity(value: self, unit: .ms)
    }

    public var kmph: Velocity {
        return Velocity(value: self, unit: .kmph)
    }

    public var mph: Velocity {
        return Velocity(value: self, unit: .mph)
    }
}

public func compute(left: Velocity, right: Velocity, operation: (Double, Double) -> Double) -> Velocity {
    let (min, max) = left.unit.rawValue < right.unit.rawValue ? (left, right) : (right, left)
    let result = operation(min.value, max.to(unit: min.unit).value)

    return Velocity(value: result, unit: min.unit)
}

public func +(left: Velocity, right: Velocity) -> Velocity {
    return compute(left, right: right, operation: +)
}

public func -(left: Velocity, right: Velocity) -> Velocity {
    return compute(left, right: right, operation: -)
}

public func *(left: Velocity, right: Velocity) -> Velocity {
    return compute(left, right: right, operation: *)
}

public func /(left: Velocity, right: Velocity) throws -> Velocity {
    guard right.value != 0 else {
        throw Error.DividedByZero
    }

    return compute(left, right: right, operation: /)
}
