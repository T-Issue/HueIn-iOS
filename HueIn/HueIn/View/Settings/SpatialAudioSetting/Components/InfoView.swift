//
//  InfoView.swift
//  HueIn
//
//  Created by Greem on 8/2/24.
//

import SwiftUI

extension SpatialAudioSettingView{
    struct InfoView: View {
        var body: some View {
            VStack(spacing:22){
                Text("Spatial audio settings").font(.hue.h1)
                Text("Move to adjust the position of\nthe sound on both sides.")
                    .minimumScaleFactor(0.8)
                    .font(.hue.body).foregroundStyle(Color(hex: "#B3B3B3"))
                    .multilineTextAlignment(.center)
            }.foregroundStyle(.white)
        }
    }
}
