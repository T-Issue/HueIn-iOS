//
//  File.swift
//  
//
//  Created by Greem on 7/30/24.
//

import Foundation
import UIKit
public protocol ReadMindfulDelegate{
    func todayTotalSeconds() async throws -> Int
    func lastWeekSecondsList() async throws -> [Date:Int]
}

public protocol HealthKitService: NSObject, ReadMindfulDelegate {
    func isHealthKitAvailable() -> Bool
    func haveAuthorization() -> Bool
    func saveMindfulSession(startTime: Date, endTime: Date) async -> Bool
    func openHealthApp()
    func getAuthorization(first:(()->())?,shown:(()->())?)
}
public extension HealthKitService{
    func openHealthApp() {
            // Health 앱을 열도록 유도하는 메시지를 사용자에게 표시
            // 딥링크가 없으므로 앱을 여는 실제 기능은 없음
            if let url = URL(string: "x-apple-health://") {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
}
