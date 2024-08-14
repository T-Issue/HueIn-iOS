//
//  File.swift
//  
//
//  Created by Greem on 7/30/24.
//

import Foundation
import HealthKit
extension HealthKitManager{
    final class ReadMindful:ReadMindfulDelegate{
        weak var healthStore: HKHealthStore!
        var writeType: HKCategoryType
        init(healthStore:HKHealthStore!,writeType: HKCategoryType) {
            self.healthStore = healthStore
            self.writeType = writeType
        }
        func todayTotalSeconds() async throws -> Int{
            let startDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())?.startOfDay
            let endDate = Date()
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
            return try await withCheckedThrowingContinuation { continuation in
                let query = HKSampleQuery(sampleType: writeType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { query, samples, error in
                    guard let samples = samples as? [HKCategorySample] else {
                        continuation.resume(throwing: HealthKitError.readSamplesError)
                        return
                    }
                    let totalSeconds:Int = samples.reduce(0) {
                        return $0 + Int($1.endDate.timeIntervalSince($1.startDate))
                    }
                    continuation.resume(returning: totalSeconds)
                    return
                }
                healthStore?.execute(query)
            }
        }
        func lastWeekSecondsList() async throws -> [Date:Int] {
            let endDate = Date()
            let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())
            // A predicate is created to filter the HealthKit samples to those that fall within the last week.
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
            return try await withCheckedThrowingContinuation { continuation in
                let query = HKSampleQuery(sampleType: writeType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { query, samples, error in
                    guard let samples = samples as? [HKCategorySample] else {
                        continuation.resume(throwing: HealthKitError.readSamplesError)
                        return
                    }
                    var res : [Date: Int] = samples.reduce(into: [:]) { dailyMindfulMinutes ,sample in
                        let seconds = sample.endDate.timeIntervalSince(sample.startDate)
                        let startDate = Calendar.current.startOfDay(for: sample.startDate)
                        if let existingMinutes = dailyMindfulMinutes[startDate] {
                            dailyMindfulMinutes[startDate] = existingMinutes + Int(seconds)
                        } else {
                            dailyMindfulMinutes[startDate] = Int(seconds)
                        }
                    }
                    for i in 0..<7{
                        var current = Calendar.current
                        current.locale = Locale(identifier: "ko_KR")
                        current.timeZone = TimeZone(identifier: "Asia/Seoul")!
                        let startDate = current.startOfDay(for: Calendar.current.date(byAdding: .day, value: -i, to: Date())!)
                        print("Date \(Date()), startDate: \(Calendar.current.startOfDay(for: Date()))")
                        res[startDate] = res[startDate] ?? 0
                    }
                    continuation.resume(returning: res)
                    return
                }
                self.healthStore?.execute(query)
            }
        }
    }
}
