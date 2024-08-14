//
//  File.swift
//  
//
//  Created by Greem on 7/30/24.
//

import Foundation
import HealthKit
public final class HealthKitManager: NSObject, HealthKitService {

    
    static let shared = HealthKitManager()
    var healthStore: HKHealthStore?
    private let writeType: HKCategoryType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.mindfulSession)!
    private lazy var readDelegate: ReadMindfulDelegate = ReadMindful(healthStore: healthStore, writeType: writeType)
    private override init() {
        super.init()
        if HKHealthStore.isHealthDataAvailable() { healthStore = HKHealthStore() }
    }
    
    public func isHealthKitAvailable() -> Bool {
        return HKHealthStore.isHealthDataAvailable()
    }
    
    public func getAuthorization(first:(()->())? = nil,shown:(()->())? = nil) {
        healthStore!.requestAuthorization(toShare: Set([writeType]), read: [writeType], completion: { (userWasShownPermissionSheet, error) in
            if userWasShownPermissionSheet {
                print("Shown sheet")
                shown?()
            } else {
                first?()
            }
        })
    }
    
    public func haveAuthorization() -> Bool {
        if isHealthKitAvailable() && healthStore!.authorizationStatus(for: writeType) == .sharingAuthorized {
            return true
        }
        return false
    }
    
    
    // 잘 저장 되었으면 true, 아니면 false
    public func saveMindfulSession(startTime: Date, endTime: Date) async -> Bool {
        guard let healthStore = healthStore, /*isMindStoreUserAllowing &&*/ self.haveAuthorization() else {
            return false
        }
        let mindfulSample = HKCategorySample(type: writeType, value: HKCategoryValue.notApplicable.rawValue, start: startTime, end: endTime)
        do{
            try await healthStore.save(mindfulSample)
            return true
        }catch{
            print(error)
            return false
        }
    }
}
extension HealthKitManager:ReadMindfulDelegate{
    public func todayTotalSeconds() async throws -> Int {
        try await readDelegate.todayTotalSeconds()
    }
    
    public func lastWeekSecondsList() async throws -> [Date : Int] {
        try await readDelegate.lastWeekSecondsList()
    }
}



