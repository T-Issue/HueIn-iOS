//
//  SettingPlusView.swift
//  HueIn
//
//  Created by Greem on 8/5/24.
//

import SwiftUI
import HueViews
import StoreKit

struct SettingSubscriptionView: View {
    @Environment(\.colorScheme) var scheme
    @Environment(\.store) var store
    @Environment(\.dismiss) var dismiss
    @State private var displayPrice : String = ""
    @State private var isLoading = false
    @State private var loadingFailed = false
    var body: some View {
        ZStack(content: {
            Rectangle().fill().overlay {
                Image(.onboardBg).resizable().scaledToFill()
            }.ignoresSafeArea(.all)
            if isLoading{
                LoadingView()
            }else{
                VStack(spacing: 24, content: {
                    Image(.lock).resizable().scaledToFit().ignoresSafeArea(.container,edges: .top)
                    VStack(spacing: 24,content: {
                        VStack(spacing: 8){
                            Text("Premium").font(.montserrat(size: 28)).foregroundStyle(.white)
                            Text("1 week free, then \(displayPrice)/month").font(.pretendard(weight: .medium, size: 20)) .foregroundStyle(.white)
                            Text("Hue.in is a meditation app that uses binaural\nbeats to help you reset your day.")
                                .multilineTextAlignment(.center)
                                .font(.pretendard(weight: .regular, size: 14)).foregroundStyle(Color(hex: "#B3B3B3"))
                        }
                        Divider().frame(height: 1).background(Color(hex: "#D3D3D3"))
                        VStack(spacing: 16){
                            InforListItem(text: "Newly Released Sound")
                            InforListItem(text: "A Developer's Love")
                        }
                    }).padding(.horizontal,26).padding(.top,-24)
                    Spacer()
                    VStack(spacing: 12){
                        bottomBtn
                        VStack{
                            Text("Subscription Terms: After free trail in one week, HueIn monthly subscription is $0.99, automatically renews unless turned off to your AppStore account. Unsused portion of free trial is forfeited after purchase.").font(.pretendard(weight: .thin, size: 11.5))  .foregroundStyle(Color(hex: "#B3B3B3")).multilineTextAlignment(.center).padding(.horizontal,12)
                                .padding(.bottom,4)
                            HStack(spacing:2) {
                                Link(destination: URL(string: "https://sage-crowley-0ac.notion.site/HueIn-Terms-92d0ba3b96f243629c6024c7b813f506")!) {
                                    Text("Terms").font(.pretendard(weight: .regular, size: 12)).underline()
                                }
                                Text(" and ").font(.pretendard(weight: .regular, size: 11))
                                Link(destination: URL(string: "https://sage-crowley-0ac.notion.site/HueIn-Privacy-Policy-7015efadbb344a67af6b050ff02af1c0")!) {
                                    Text("Privacy Policy").font(.pretendard(weight: .regular, size: 12)).underline()
                                }
                            }.foregroundStyle(.white)
                        }
                    }
                }).ignoresSafeArea(.container,edges: .top)
            }
            VStack(spacing: 0 ,content: {
                HStack(content: {
                    HueViews.HueButton.Close{ dismiss() }
                    Spacer()
                }).padding(.horizontal,16)
                Spacer()
            
            })
        })
        .alert("Please try again", isPresented: $loadingFailed, actions: {
            Button(role: .cancel) {
                dismiss()
            } label: {
                Text("Close")
            }
        })
        .onAppear(){
            isLoading = true
            Task{
                try await Task.sleep(for: .seconds(3))
                if isLoading{
                    await MainActor.run { loadingFailed = true }
                }
            }
            Task{
                try await store.loadProducts()
                await store.updatePurchasedProducts()
                self.displayPrice = store.products.first?.displayPrice ?? ""
                await MainActor.run { isLoading = false }
                for await event in await store.eventAsyncStream(){
                    switch event{
                    case .userProUpdated(let isUpdated):
                        if isUpdated{ await MainActor.run { self.dismiss() } }
                        self.displayPrice = store.products.first?.displayPrice ?? ""
                    }
                }
            }
        }
    }
    var bottomBtn: some View{
        VStack(spacing: 14,content: {
                Button(action: {
                    isLoading = true
                    Task{
                        try await store.purchase()
                        await MainActor.run { isLoading = false }
                    }
                }, label: {
                    purchaseButton.padding(.horizontal,20)
                })
                Button(action: {
                    Task{
                        if await store.restore(){
                            print("restore가 끝났다.")
                        }else{
                            print("문제가 있다")
                        }
                    }
                }, label: {
                    Text("Restore Purchase")
                        .foregroundStyle(Color(hex: "#B3B3B3"))
                        .font(.pretendard(weight: .regular, size: 16))
                })
            })
    }
    struct InforListItem: View {
        var text: String
        var body: some View {
            HStack(spacing: 8,content: {
                Image(systemName: "checkmark").font(.system(size: 17,weight: .medium))
                Text(text).font(.pretendard(weight: .medium, size: 17))
            }).foregroundStyle(.white)
        }
    }
    
}
extension SettingSubscriptionView{
    var purchaseButton: some View{
            HStack{
                Spacer()
                VStack(spacing: 7){
                    Text("Subscribe")
                        .font(.montserrat(size: 20))
                }.foregroundStyle(.white)
                Spacer()
            }
            .padding(.vertical,12)
            .padding(.leading,24)
            .padding(.trailing,16)
            .pressBorder()
            .btnGradient(isActive: true)
            .background(.regularMaterial.opacity(0.2))
            .clipShape(Capsule())
    }
    var priceInfoView: some View{
        VStack{
            Text("\(displayPrice)/month")
            VStack(spacing: 7){
                Text("Try a week")
                    .font(.montserrat(size: 20))
                Text("then, Monthly \(displayPrice)").font(.pretendard(weight: .regular, size: 16)).minimumScaleFactor(0.5)
            }.foregroundStyle(.white)
        }
        .padding(.vertical,12)
        .padding(.leading,24)
        .padding(.trailing,16)
        .pressBorder()
        .btnGradient(isActive: false)
        .background(.regularMaterial.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
extension View{
    @ViewBuilder func btnGradient(isActive: Bool) -> some View{
        let bgGradient = LinearGradient(colors: [Color(hex: "#787E95"),Color(hex: "#88B8F1"),Color(hex: "#88B8F1")], startPoint: .leading, endPoint: .trailing)
        if isActive{
            self.background(bgGradient.opacity(0.5))
        }else{
            self
        }
    }
}

#Preview {
    SettingSubscriptionView()
}
