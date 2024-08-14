//
//  File.swift
//  
//
//  Created by Greem on 7/29/24.
//

import HueDesignSystem
import SwiftUI

 public struct HueConfirmLabel: View{
    var text:String
    var activeGradient:Bool
    var imageResource:ImageResource? = nil
    public init(text: String, activeGradient: Bool, imageResource: ImageResource? = nil) {
        self.text = text
        self.activeGradient = activeGradient
        self.imageResource = imageResource
    }
    public var body: some View{
        HStack{
            if imageResource == nil{ Spacer() }
            Text(text)
                .font(.montserrat(size: 20))
                .foregroundStyle(.white)
            Spacer()
            if let imageResource{
                Image(imageResource).resizable().frame(width: 20,height: 20)
            }
        }
        .padding(.vertical,22)
        .padding(.leading,24)
        .padding(.trailing,16)
        .pressBorder()
        .isActiveGradient(activeGradient)
        .background(.regularMaterial.opacity(0.2))
        .preferredColorScheme(.light)
        .clipShape(Capsule())
    }
}
extension View{
    @ViewBuilder func isActiveGradient(_ isActive: Bool) -> some View{
        let bgGradient = LinearGradient(colors: [Color(hex: "#787E95"),Color(hex: "#88B8F1"),Color(hex: "#88B8F1")], startPoint: .leading, endPoint: .trailing)
        if isActive{
            self.background(bgGradient.opacity(0.5))
        }else{
            self
        }
    }
}
