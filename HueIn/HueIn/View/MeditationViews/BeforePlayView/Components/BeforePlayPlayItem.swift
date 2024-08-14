//
//  BeforePlayPlayItem.swift
//  HueIn
//
//  Created by Greem on 8/1/24.
//

import SwiftUI
import HueViews
extension BeforePlayingView{
    struct PlayItemView: View {
        @Binding var seconds: Int
        var body: some View {
            HStack(spacing: 0){
                HueButton.Minus(isActive: seconds > 30 ){
                    if seconds > 30{ seconds -= 15 }
                }
                Spacer()
                if seconds < 60{
                    Text("\(seconds % 60)s").font(.hue.title2).foregroundStyle(.white)
                }else{
                    Text("\(seconds / 60)m \(seconds % 60)s").font(.hue.title2).foregroundStyle(.white)
                }
                Spacer()
                HueButton.Plus(isActive: seconds < 90) {
                    if seconds < 90{ seconds += 15 }
                }
            }.padding(.horizontal,50)
        }
    }
}
