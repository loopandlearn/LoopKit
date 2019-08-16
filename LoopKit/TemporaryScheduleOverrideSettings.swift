//
//  TemporaryScheduleOverrideSettings.swift
//  LoopKit
//
//  Created by Michael Pangburn on 1/2/19.
//  Copyright © 2019 LoopKit Authors. All rights reserved.
//

import HealthKit


public struct TemporaryScheduleOverrideSettings: Hashable {
    private var targetRangeInMgdl: DoubleRange?
    public var insulinNeedsScaleFactor: Double?

    public var targetRange: ClosedRange<HKQuantity>? {
        return targetRangeInMgdl.map { $0.quantityRange(for: .milligramsPerDeciliter) }
    }

    public var basalRateMultiplier: Double? {
        return insulinNeedsScaleFactor
    }

    public var insulinSensitivityMultiplier: Double? {
        return insulinNeedsScaleFactor.map { 1.0 / $0 }
    }

    public var carbRatioMultiplier: Double? {
        return insulinNeedsScaleFactor.map { 1.0 / $0 }
    }

    public var effectiveInsulinNeedsScaleFactor: Double {
        return insulinNeedsScaleFactor ?? 1.0
    }

    public init(unit: HKUnit, targetRange: DoubleRange?, insulinNeedsScaleFactor: Double? = nil) {
        self.targetRangeInMgdl = targetRange?.quantityRange(for: unit).doubleRange(for: .milligramsPerDeciliter)
        self.insulinNeedsScaleFactor = insulinNeedsScaleFactor
    }
}

extension TemporaryScheduleOverrideSettings: RawRepresentable {
    public typealias RawValue = [String: Any]

    private enum Key {
        static let targetRange = "targetRange"
        static let insulinNeedsScaleFactor = "insulinNeedsScaleFactor"
    }

    public init?(rawValue: RawValue) {
        if let targetRangeRawValue = rawValue[Key.targetRange] as? DoubleRange.RawValue,
            let targetRange = DoubleRange(rawValue: targetRangeRawValue) {
            self.targetRangeInMgdl = targetRange
        }

        self.insulinNeedsScaleFactor = rawValue[Key.insulinNeedsScaleFactor] as? Double
    }

    public var rawValue: RawValue {
        var raw: RawValue = [:]

        if let targetRange = targetRangeInMgdl {
            raw[Key.targetRange] = targetRange.rawValue
        }

        if let insulinNeedsScaleFactor = insulinNeedsScaleFactor {
            raw[Key.insulinNeedsScaleFactor] = insulinNeedsScaleFactor
        }

        return raw
    }
}
