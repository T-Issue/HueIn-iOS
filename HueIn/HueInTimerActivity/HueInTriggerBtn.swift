//
//  HueInTriggerBtn.swift
//  HueIn
//
//  Created by Greem on 8/13/24.
//

import SwiftUI
import ActivityKit
import WidgetKit
import AppIntents

extension HueInTimerActivityLiveActivity{
    struct TriggerBtn: View {
        var body: some View {
            Toggle(isOn: false, intent: StopMediIntent()){
                Text("Stop").font(.custom("Pretendard-SemiBold", size: 20)).minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .foregroundStyle(.white)
                    .padding(.horizontal,20)
                    .padding(.vertical,9)
                    .background(.regularMaterial.opacity(0.25))
                    .clipShape(Capsule())
                    
            }.buttonBorderShape(.capsule).buttonStyle(.plain)
        }
    }
}
