//
//  OnboardBinaural.swift
//  HueIn
//
//  Created by Greem on 7/31/24.
//
import SwiftUI

struct OnboardBinaural: View {
    @Binding var isShown: Int
    var body: some View {
        VStack(spacing:40){
            ZStack{
                Image(.onboardingHead).resizable().scaledToFill().clipped()
                Image(.onboardingHeadBack).resizable().aspectRatio(contentMode: .fill)
                    .opacity(isShown == 1 ? 1  : 0).animation(.interactiveSpring(duration: 0.5)
                                                              ,value: isShown)
                    .clipped()
            }.padding(.horizontal,0).frame(height: 200).padding(.top,124)
            VStack(spacing: 23){
                Text("Binaural Beat").font(.hue.h1)
                Text("Binaural beats use two different frequencies\nto guide the braininto a specific state.\nExperience it on Hue.in").minimumScaleFactor(0.4).font(.hue.body)
                    .foregroundStyle(Color(hex: "#B3B3B3"))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal,30)
            }
            Spacer()
        }
        .font(.system(size: 24,weight: .semibold)).foregroundStyle(.white)
    }
}


#Preview {
    OnboardingView(onboard: .constant(true))
}
