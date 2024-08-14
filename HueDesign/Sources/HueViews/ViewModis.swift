//
//  File.swift
//  
//
//  Created by Greem on 7/29/24.
//

import SwiftUI
import HueDesignSystem

extension View{
    @ViewBuilder public func pressBorder() -> some View{
        self.modifier(PressBorder())
    }
}

struct PressBorder:ViewModifier{
    func body(content: Content) -> some View {
        content.background{
            let gradient = LinearGradient(colors: [.white,Color(hex: "#666666").opacity(0)], startPoint: .top, endPoint: .bottom)
            Capsule().fill(.clear)
                .stroke(.white.opacity(0.1), style: StrokeStyle(lineWidth: 2))
                .stroke(gradient.opacity(0.5),style: StrokeStyle(lineWidth: 2))
        }
    }
}
