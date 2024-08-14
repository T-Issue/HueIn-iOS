//
//  TimerText.swift
//  HueIn
//
//  Created by Greem on 8/5/24.
//

import SwiftUI
import WidgetKit
extension HueInTimerActivityLiveActivity{
    struct TimerText: View {
        let context: ActivityViewContext<MediAttributes>
        var body: some View {
            HStack{
                focusItem
                VStack(alignment:.leading,spacing: 6){
                    Text("Hue.in")
                        .foregroundStyle(Color(hex: "#9F9F9F"))
                        .font(.custom("Montserrat-SemiBold", size: 12))
                    VStack(alignment: .leading,spacing: 2,content: {
                        Text(context.state.mediType.item.title)
                            .font(.custom("Montserrat-SemiBold", size: 16))
                            .frame(height: 20)
                        Text(timerInterval: Date.now...Date(timeInterval: TimeInterval(context.state.restCount), since: .now))
                            .font(.custom("Montserrat-SemiBold", size: 42))
                    }).foregroundStyle(.white)
                }
                Spacer()
                TriggerBtn()
            }
        }
        var focusItem: some View{
            Group{
                switch context.state.mediType {
                case .free:
                    Image(.liveFeelFree).resizable().scaledToFit().frame(width: 88,height: 88)
                case .happy:
                    Image(.liveHappiness).resizable().scaledToFit().frame(width: 88,height: 88)
                case .destress:
                    Image(.liveDestress).resizable().scaledToFit().frame(width: 88,height: 88)
                case .concentrate:
                    Image(.liveConcetnrate).resizable().scaledToFit().frame(width: 88,height: 88)
                case .confidence:
                    Image(.liveConfidence).resizable().scaledToFit().frame(width: 88,height: 88 )
                }
            }
        }
    }
    
}
