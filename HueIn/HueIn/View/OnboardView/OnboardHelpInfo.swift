//
//  OnboardHelpInfo.swift
//  HueIn
//
//  Created by Greem on 7/31/24.
//

import SwiftUI
import HueDesignSystem

struct OnboardHelpInfo: View {
    var body: some View {
        VStack(spacing:50){
            Image(.onborardingOne).resizable()
                .aspectRatio(contentMode: .fit).padding(.horizontal,36).padding(.top,50).frame(height: 300)
            VStack(spacing: 23){
                Text("Help you start your day!").font(.hue.h1).frame(height: 44)
                Text("Hue.in is an app that helps\nwith breathing and mindfulness,\nand lets you record today's mindset.").font(.hue.body).minimumScaleFactor(0.8)
                    .foregroundStyle(Color(hex: "#B3B3B3"))
                    .multilineTextAlignment(.center)
            }
            Spacer()
        }
        .font(.system(size: 24,weight: .semibold))
        .foregroundStyle(.white)
    }
}
