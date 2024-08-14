//
//  File.swift
//  
//
//  Created by Greem on 7/27/24.
//

import SwiftUI

public struct HueDesignSystemTextView: View {
    public var body: some View {
        Text("Hello world").font(.pretendard(weight: .semibold, size: 72))
    }
}

struct LogoView_Previews: PreviewProvider {
    static var previews: some View {
        HueDesignSystemTextView().loadHueFontSystem()
    }
}
