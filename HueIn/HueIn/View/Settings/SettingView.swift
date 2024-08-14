//
//  SettingView.swift
//  HueIn
//
//  Created by Greem on 8/1/24.
//

import SwiftUI
import HueViews
import HueDesignSystem
import Health_Remind

struct SettingView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.health) var health
    @Environment(\.navigationControllerState) var naviState
    @Environment(\.store) var store
    @Binding var paths:[StackViewType]
    @State private var isHealthKitAvailable = false
    @State private var unlockToggle = false
    @State private var isPro = false
    var body: some View {
        ZStack{
            Rectangle().fill().overlay {
                Image(.onboardBg).resizable().scaledToFill()
            }.ignoresSafeArea(.all)
            VStack(spacing: 0 ,content: {
                SettingNavigationView().padding(.horizontal,16).padding(.bottom,8)
                ScrollView {
                    VStack(spacing: 0){
                        if !isPro{
                            VStack(alignment:.leading,spacing: 17){
                                HueViews.HueButton.Unlock{
                                    unlockToggle = true
                                }
                                Text("Unlocking the premium features will allow you to experience new days.").font(.pretendard(weight: .medium, size: 14)).foregroundStyle(Color(hex: "#FFFFFF").opacity(0.5)).padding(.horizontal,12)
                            }.padding(.horizontal,16).padding(.top,40).padding(.bottom,34)
                            .fullScreenCover(isPresented: $unlockToggle, content: {
                                    SettingSubscriptionView()
                                })
                        }else{
                            Rectangle().fill(.clear).frame(height: 32)
                        }
                        SettlingListView(paths: $paths)
                        Spacer()
                        
                    }
                }
                Spacer()
                HStack (spacing: 4){
                    Link(destination: URL(string: "https://sage-crowley-0ac.notion.site/HueIn-Terms-92d0ba3b96f243629c6024c7b813f506")!) {
                        Text("TERMS")
                    }
                    Image(.dot).resizable().frame(width: 2,height:2)
                    Link(destination: URL(string: "https://sage-crowley-0ac.notion.site/HueIn-Privacy-Policy-7015efadbb344a67af6b050ff02af1c0")!) {
                        Text("PRIVACY POLICY")
                    }
                }.font(.pretendard(weight: .medium, size: 14)).foregroundStyle(Color(hex: "D9D9D9"))
            })
        }.toolbar(.hidden, for: .navigationBar)
            .onAppear(){
                isHealthKitAvailable = health.isHealthKitAvailable()
                naviState.allowsSwipeBack = true
            }.onAppear(){
                Task{
                    try await store.loadProducts()
                    await store.updatePurchasedProducts()
                    await MainActor.run {
                        self.isPro = store.isProUser
                        print(isPro)
                    }
                    for await purchaseEvent in await store.eventAsyncStream(){
                        switch purchaseEvent{
                        case .userProUpdated(let isPro):
                            await MainActor.run { self.isPro = isPro }
                        }
                    }
                }
                
            }
    }
}


#Preview{
    @State var go:[StackViewType] = []
    return SettingView(paths: $go)
}
