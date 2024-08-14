//
//  ExplainView.swift
//  HueIn
//
//  Created by Greem on 8/1/24.
//

import SwiftUI

extension FinishView{
    struct ExplainView:View {
        let medi: MediItem
        var body: some View {
            VStack(spacing: 14){
                Text(medi.title).font(.hue.h1).foregroundStyle(.white).frame(height: 44)
                Text(medi.afterInfo).font(.hue.body)
                    .multilineTextAlignment(.center).foregroundStyle(Color.desc)
            }
        }
    }
}
