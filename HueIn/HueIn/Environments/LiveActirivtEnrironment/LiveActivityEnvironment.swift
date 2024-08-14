//
//  LiveActivityEnvironment.swift
//  HueIn
//
//  Created by Greem on 8/5/24.
//

import SwiftUI
import ActivityKit

struct LiveActivityEnvironmentKey : EnvironmentKey{
    static var defaultValue: MediLiveActivity = MediLiveActivityImpl.shared
}
extension EnvironmentValues{
    var mediLiveActivity: MediLiveActivity{
        get{ self[LiveActivityEnvironmentKey.self] }
        set{ self[LiveActivityEnvironmentKey.self] = newValue }
    }
}

protocol MediLiveActivity{
    // 기존에 없으면 라이브 액티비티를 추가하고 존재하면 라이브 액티비티 값을 바꾸는 메서드
    func updateActivity(mediType:Medi) async
    func addActivity(mediType:Medi,count:Int)  async
    func createActivity(mediType:Medi,count:Int) async
    func removeActivity() async
    func removeActivity(dismissPolicy: ActivityUIDismissalPolicy) async
}
