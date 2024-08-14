//
//  ListCardView.swift
//  HueIn
//
//  Created by Greem on 8/6/24.
//

import Foundation
import SwiftUI


struct CardView: View{
    var item:MediItem
    var isLocked: Bool
    var action:(()->())?
    var body: some View{
        Button{
        }label:{
            ZStack{
                VStack{
                    HStack{
                        VStack(alignment:.leading,spacing:11){
                            Text(item.title).font(.hue.display2)
                            Text(item.desc).font(.hue.caption)
                        }
                        Spacer()
                    }.padding([.leading,.top],25).foregroundStyle(.white)
                    Spacer()
                    Image(item.paths.thumbnail).resizable().aspectRatio(contentMode: .fit)
                        .padding(.horizontal,12)
                    Spacer()
                }.blur(radius: isLocked ? 4 : 0)
                if isLocked{
                    Image(.itemLock).resizable().scaledToFit().padding(.horizontal,25)
                }
            }
            .frame(width: 230)
            .background(.regularMaterial.opacity(0.33),in: RoundedRectangle(cornerRadius: 15))
            .overlay(content: {
                RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 1).foregroundStyle(.white.opacity(0.5))
            })
            .clipShape(RoundedRectangle(cornerRadius: 15,style: .circular))
            .environment(\.colorScheme, .light)
        }
        .buttonStyle(CardButtonStyle{
            action?()
        })
        .scrollTransition(.interactive,axis: .horizontal){ view,phase in
            view.scaleEffect(phase.isIdentity ? 1 : 0.95)
        }
    }
}
struct CardButtonStyle: ButtonStyle{
    var afterAction:(()->())?
    func makeBody(configuration: Configuration) -> some View {
        configuration.label.scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.smooth(duration: 0.125), value: configuration.isPressed)
            .onChange(of: configuration.isPressed) { oldValue, newValue in
                if oldValue && !newValue{
                    Task{
                        try await Task.sleep(for: .seconds(0.125))
                        await MainActor.run {
                            afterAction?()
                        }
                    }
                }
            }
    }
    
}
