//
//  Entities.swift
//  SingleMetricWidget
//
//  Created by Ben Yang on 12/12/24.
//
import Foundation

enum Status {
    case higherThanNormal
    case normal
    case lowerThanNormal
}

struct ValueWithStatus {
    let value: Double
    let status: Status
}

struct HealthMetricData {
    let sleepScore: Double
    let recoveryScore: Double
    let strainScore: Double
    let strainTargetRange: (Double, Double)
    let timeAsleepMinutes: ValueWithStatus
    let timeInBedMinutes: ValueWithStatus
    let restingHeartRate: ValueWithStatus
    let heartRateVariability: ValueWithStatus
    let exerciseMinutes: ValueWithStatus
    let caloriesBurned: ValueWithStatus
}

class MetricDataService {
    func getMetricData() -> HealthMetricData {
        return HealthMetricData(
            sleepScore: 75,
            recoveryScore: 60,
            strainScore: 40,
            strainTargetRange: (50, 60),
            timeAsleepMinutes: ValueWithStatus(value: 472, status: .lowerThanNormal),
            timeInBedMinutes: ValueWithStatus(value: 482, status: .higherThanNormal),
            restingHeartRate: ValueWithStatus(value: 59, status: .lowerThanNormal),
            heartRateVariability: ValueWithStatus(value: 85, status: .higherThanNormal),
            exerciseMinutes: ValueWithStatus(value: 75, status: .higherThanNormal),
            caloriesBurned: ValueWithStatus(value: 654, status: .lowerThanNormal)
        )
    }
}
