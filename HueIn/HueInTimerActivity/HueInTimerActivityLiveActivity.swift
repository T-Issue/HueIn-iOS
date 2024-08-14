//
//  HueInTimerActivityLiveActivity.swift
//  HueInTimerActivity
//
//  Created by Greem on 8/5/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct HueInTimerActivityLiveActivity: Widget {
    var body: some WidgetConfiguration {
        return ActivityConfiguration(for: MediAttributes.self) { context in
            // Lock screen/banner UI goes here
            TimerText(context: context).padding(.vertical,25)
                .padding(.horizontal,20)
                .activityBackgroundTint(Color(hex: "#252525").opacity(0.6))
            .activitySystemActionForegroundColor(Color.black)
            
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.center) {
                    TimerText(context: context)
                        .padding(.horizontal, 12)
                    .activityBackgroundTint(Color(hex: "#252525").opacity(0.6))
                    .activitySystemActionForegroundColor(Color.black)
                }
            } compactLeading: {
                compactImages(context: context)
            } compactTrailing: {
                Text(timerInterval: Date.now...Date(timeInterval: TimeInterval(context.state.restCount), since: .now))
                    .font(.custom("Montserrat-SemiBold", size: 15))
                    .foregroundStyle(.white)
                    .frame(width: 42)
            } minimal: {
                compactImages(context: context)
            }
        }
    }
    func compactImages(context: ActivityViewContext<MediAttributes>)-> some View{
        switch context.state.mediType{
        case .concentrate:
            Image(.compactConcentrate).resizable().frame(width: 24,height: 24)
        case .confidence:
            Image(.compactConfidence).resizable().frame(width: 24,height: 24)
        case .destress:
            Image(.compactDestress).resizable().frame(width: 24,height: 24)
        case .free:
            Image(.compactFree).resizable().frame(width: 24,height: 24)
        case .happy:
            Image(.compactHappiness).resizable().frame(width: 24,height: 24)
        }
    }
}
