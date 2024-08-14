//
//  BeforePlayView.swift
//  HueIn
//
//  Created by Greem on 8/1/24.
//
import SwiftUI
import HueViews

struct BeforePlayingView: View{
    @Environment(\.dismiss) var dismiss
    @Environment(\.navigationControllerState) var naviState
    @Environment(\.hueStorage) var storage
    @Environment(\.spatialAudio) var spatial
    @Binding var paths: [StackViewType]
    @State private var isLike = false
    @State private var seconds:Int = 30
    @State private var isPlayAvailable = false
    let mediItem: MediItem
    var body: some View{
        ZStack{
            BackgroundView(mediItem: mediItem)
            VStack{
                NavigationView(mediItem: mediItem)
                ExplainView(mediItem: mediItem)
                VStack(spacing:70){
                    PlayItemView(seconds: $seconds)
                    HueButton.Start(text: isPlayAvailable ? "Let's get started" : "Wait a few seconds",
                                    isActive: isPlayAvailable) {
                        paths.append(.playing(mediItem,seconds))
                    }.frame(height: 66).padding(.horizontal,20).allowsHitTesting(isPlayAvailable)
                }
                .padding(.bottom,32)
            }
        }.toolbar(.hidden, for: .navigationBar)
        .onAppear(){ naviState.allowsSwipeBack = true }
        .onAppear(){
            Task{
                try await spatial.soundReady(leftPath: mediItem.paths.leftSound, rightPath: mediItem.paths.rightSound, format: "mp3")
                await MainActor.run {
                    print("다시 나타남")
                    withAnimation { isPlayAvailable = true }
                }
            }
        }
        .onDisappear(){
            isPlayAvailable = false
        }
    }
}
extension BeforePlayingView{
    struct NavigationView:View {
        @Environment(\.dismiss) var dismiss
        @Environment(\.hueStorage) var storage
        let mediItem: MediItem
        @State private var isLike = false
        var body: some View {
            HStack{
                HueButton.Back{ dismiss() }
                Spacer()
                /*
                HueButton.Heart(isLike: $isLike) { isLike in
                    do{
                        var likedMeis = try storage.likedMedis
                        let medi = Medi(rawValue: mediItem.id)!
                        if isLike{
                            likedMeis.insert(medi)
                        }else{
                            likedMeis.remove(medi)
                        }
                        try storage.update(likedMedis: likedMeis)
                    }catch{
                        print("저장이 잘 되지 않음!!")
                    }
                }
                */
            }.padding(.horizontal,20)
                .onAppear(){
                    do{
                        print("불린다!!")
                        let datas = try storage.likedMedis
                        let medi = Medi(rawValue: mediItem.id)!
                        print(datas)
                        self.isLike = datas.contains(medi)
                    }catch{
                        print("There is no like")
                    }
                }
        }
    }
}
