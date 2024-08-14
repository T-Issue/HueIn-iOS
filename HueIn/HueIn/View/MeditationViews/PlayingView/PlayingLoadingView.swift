//
//  PlayingLoadingView.swift
//  HueIn
//
//  Created by Greem on 8/13/24.
//

import SwiftUI

struct PlayingLoadingView:View{
    var body: some View{
        Rectangle().fill().overlay {
            Image(.onboardBg).resizable().scaledToFill()
        }.overlay{
            LoadingView()
        }.ignoresSafeArea(.all)
    }
}
