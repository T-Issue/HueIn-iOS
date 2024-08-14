//
//  LoadingView.swift
//  HueIn
//
//  Created by Greem on 8/6/24.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        LottieView(fileName: "Loading", loopMode: .loop)
    }
}

#Preview {
    LoadingView()
}
