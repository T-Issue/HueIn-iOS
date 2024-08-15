//
//  ListView.swift
//  HueIn
//
//  Created by Greem on 8/1/24.
//

import Foundation
import SwiftUI
import HueViews

struct ListView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.navigationControllerState) var naviState
    @Environment(\.hueStorage) var hueStorage
    @Environment(\.store) var store
    @Environment(\.spatialAudio) var spatials
    @State private var values:[MediItem] = []
    @State var paths: [StackViewType] = []
    @State private var isPro = false
    @State private var promotionPresent = false
    var body: some View {
        NavigationStack(path: $paths){
            ZStack{
                Rectangle().fill().overlay {
                    Image(.homeBackground).resizable().scaledToFill()
                }.ignoresSafeArea(.all)
                VStack {
                    HStack(content: {
                        Spacer()
                        HueViews.HueButton.Setting { paths.append(.setting) }
                    }).padding(.horizontal,16)
                    HStack{
                        VStack(alignment:.leading,spacing:8){
                            Text("What kind of day\nwould you like to have?").font(.montserrat(size: 28)).foregroundStyle(.white).frame(height: 80)
                            Text("5 mindfulness exercises are ready for you").font(.hue.body).foregroundStyle(.gray)
                        }
                        Spacer()
                    }.padding(.horizontal,20)
                    Spacer()
                    HueSlider(items: $values, spacing: 14, itemWidth: 290, sliderHeight: 360, paddingLeading: 20) { value,idx in
                        Group{
                            if isPro{
                                CardView (item: value,isLocked: false){
                                    paths.append(.beforePlaying(value))
                                }
                            }else{
                                if idx == 0{
                                    CardView (item: value,isLocked: false){
                                        paths.append(.beforePlaying(value))
                                    }
                                }else{
                                    CardView (item: value,isLocked: true){
                                        promotionPresent.toggle()
                                    }
                                }
                            }
                        }.fullScreenCover(isPresented: $promotionPresent) {
                            SettingSubscriptionView()
                        }
                    }
                    .onAppear(){
                        self.values = Medi.allCases.compactMap{[mediItems = hueStorage.mediItems] item in
                            mediItems[item]
                        }
                        Task{ try? await spatials.soundStop() }
                        Task{
                            try await store.loadProducts()
                            await store.updatePurchasedProducts()
                            await MainActor.run { 
                                self.isPro = store.isProUser
                            }
                            for await purchaseEvent in await store.eventAsyncStream(){
                                switch purchaseEvent{
                                case .userProUpdated(let isPro):
                                    await MainActor.run { self.isPro = isPro }
                                }
                            }
                        }
                    }
                    Spacer()
                }
            }
            .naviDestination(paths: $paths)
            .onAppear(){ naviState.allowsSwipeBack = true }
        }
    }
}
fileprivate extension View{
    func naviDestination(paths: Binding<[StackViewType]>) -> some View{
        self.navigationDestination(for: StackViewType.self) { type in
            switch type{
            case .beforePlaying(let mediItem): BeforePlayingView(paths: paths,mediItem: mediItem)
            case .playing(let mediItem,let playTime): PlayingView(mediItem: mediItem, playTime: playTime, paths: paths)
            case .finish(let mediItem): FinishView(paths: paths,mediItem: mediItem)
            case .settingDetail(let type):
                switch type{
                case .health: ConnectAppleHealth(paths: paths)
                case .spatialAudio: SpatialAudioSettingView(paths: paths)
                }
            case .setting: SettingView(paths: paths)
            default: EmptyView()
            }
        }
    }
}

#Preview {
    ListView()
}
