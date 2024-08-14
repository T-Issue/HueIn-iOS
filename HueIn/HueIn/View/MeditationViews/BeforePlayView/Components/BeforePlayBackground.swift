//
//  BeforePlayBackground.swift
//  HueIn
//
//  Created by Greem on 8/1/24.
//

import SwiftUI

extension BeforePlayingView{
    struct BackgroundView: View {
        let mediItem:MediItem
        var body: some View {
            Rectangle().fill().overlay {
                ZStack{
                    Image(.onboardBg).resizable().scaledToFill()
                    Image(mediItem.paths.pendingGradient).resizable().scaledToFill()
                }
            }.ignoresSafeArea(.all)
        }
    }
}
