//
//  BeforePlayExplain.swift
//  HueIn
//
//  Created by Greem on 8/1/24.
//

import SwiftUI

extension BeforePlayingView{
    struct ExplainView:View {
        let mediItem: MediItem
        var body: some View {
            Group{
                VStack(spacing:14){
                    Text(mediItem.title).font(.hue.display1)
                    Text(mediItem.desc).font(.hue.h2)
                }.foregroundStyle(.white)
                Spacer()
                VStack(spacing: 34){
                    Image(mediItem.paths.thumbnail).resizable().aspectRatio(contentMode: .fit).frame(width: 200,height: 200)
                    Text(mediItem.beforeInfo).font(.hue.body).multilineTextAlignment(.center)
                        .padding(.horizontal,40)
                }.foregroundStyle(.white)
                Spacer()
                Spacer()
            }
        }
    }
}
