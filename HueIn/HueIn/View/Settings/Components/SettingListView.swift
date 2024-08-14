//
//  SettingListView.swift
//  HueIn
//
//  Created by Greem on 8/2/24.
//

import SwiftUI
import HueViews

extension SettingView{
    struct SettlingListView: View {
        @Binding var paths: [StackViewType]
        var body: some View {
            VStack(spacing:0,content: {
                Divider().frame(height: 0.5).background(.white.opacity(0.3)).padding(.horizontal,16)
                HueViews.HueButton.ListCell(text: "Spatial Audio Setting", desc: "Position of audio on both sides can be adjusted") {
                    paths.append(.settingDetail(.spatialAudio))
                }.padding(.horizontal,20)
                Divider().frame(height: 0.5).background(.white.opacity(0.3)).padding(.horizontal,16)
                HueViews.HueButton.ListCell(text: "Connect Apple Health", desc: "Monitor your health goals with Apple Health") {
                    paths.append(.settingDetail(.health))
                }.padding(.horizontal,20)
            })
        }
    }
}
