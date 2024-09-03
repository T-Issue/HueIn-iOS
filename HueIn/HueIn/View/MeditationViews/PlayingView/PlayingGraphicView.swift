//
//  PlayingGraphicView.swift
//  HueIn
//
//  Created by Greem on 8/13/24.
//

import SwiftUI

struct PlayingGraphicView: View {
    let mediItem: MediItem
    @Binding var nowTime:Int
    var body: some View {
        Rectangle().fill().overlay {
//            Image(.onboardBg).resizable().scaledToFill()
            Rectangle().fill(.black)
        }.overlay{
            LottieView(fileName: mediItem.paths.playingGraphic, loopMode: .loop)
        }
        .overlay{ LottieView(fileName: "Breath", loopMode: .loop) }
        .overlay(alignment: .center, content: {
            VStack{
                Spacer()
                HStack(spacing: 5){
                    Image(.timer).resizable().frame(width: 24,height: 24)
                    Text(timerInterval: Date.now...Date(timeInterval: TimeInterval(nowTime), since: .now))
                        .font(.pretendard(weight: .regular, size: 20)).foregroundStyle(.white.opacity(0.5))
                }
                ForEach(0..<3,id:\.self){idx in Spacer()}
            }
        })
        .ignoresSafeArea(.all)
    }
}
