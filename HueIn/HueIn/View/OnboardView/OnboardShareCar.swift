//
//  OnboardShareCar.swift
//  HueIn
//
//  Created by Greem on 7/31/24.
//

import SwiftUI

struct OnboardShareCar: View {
    @Binding var isShown: Int
    var body: some View {
        VStack(spacing:31){
            ZStack{
//                Image(.onboarding2).resizable().aspectRatio(contentMode: .fit)
                Image(.onborardingCar).resizable().aspectRatio(contentMode: .fit)
                Image(.onboardingCarBack).resizable().aspectRatio(contentMode: .fit)
                    .opacity(isShown == 1 ? 1  : 0).animation(.interactiveSpring(duration: 0.5)
                                                              ,value: isShown)
            }.padding(.horizontal,0).padding(.top,21)
            VStack(spacing: 8){
                Text("차안에서도 함께 즐길 수 있어요.").font(.hue.h1).frame(height: 44)
                Text("시작하고 싶은 마음가짐들을 클릭하면\n호흡과 마음챙김을 도와줍니다.").font(.hue.body)
                    .foregroundStyle(Color(hex: "#B3B3B3"))
                    .multilineTextAlignment(.center)
            }
            Spacer()
        }
        .font(.system(size: 24,weight: .semibold)).foregroundStyle(.white)
    }
}
