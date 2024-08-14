//
//  SettingNavigationView.swift
//  HueIn
//
//  Created by Greem on 8/2/24.
//

import SwiftUI
import HueViews

extension SettingView{
    struct SettingNavigationView:View {
        @Environment(\.dismiss) var dismiss
        var body: some View {
            HStack(content: {
                HueViews.HueButton.Back{
                    dismiss()
                }
                Spacer()
            })
        }
    }
}
