//
//  PlayingView.swift
//  HueIn
//
//  Created by Greem on 8/1/24.
//

import SwiftUI
import HueViews
import HueDesignSystem

struct PlayingView:View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.scenePhase) var scene
    @Environment(\.navigationControllerState) var naviState
    @Environment(\.mediLiveActivity) var mediLiveActivity
    @Environment(\.spatialAudio) var spatial
    @Environment(\.health) var health
    let mediItem: MediItem
    let playTime: Int
    @State var nowTime: Int = 0
    @State private var isFinished: Bool = false
    @Binding var paths: [StackViewType]
    @State private var startDate: Date = Date()
    @State private var isStarted: Bool = false
    var body: some View {
        ZStack{
            setLiveActivity
            if isStarted{
                PlayingGraphicView(mediItem: mediItem,nowTime: $nowTime)
            }else{
                PlayingLoadingView()
            }
            VStack{
                HStack{
                    HueButton.Back{
                        isStarted = false
                        Task{ try await spatial.soundStop() }
                        dismiss()
                    }
                    Spacer()
                }.padding(.horizontal,20)
                Spacer()
            }
        }
        .onAppear(){ naviState.allowsSwipeBack = false }
        .onAppear() {
            Task{
                await mediLiveActivity.addActivity(mediType: Medi(rawValue: mediItem.id)!, count: playTime)
                try await spatial.soundStart(leftPath: mediItem.paths.leftSound, rightPath: mediItem.paths.rightSound, format: "mp3")
                await MainActor.run {
                    startDate = Date()
                    nowTime = playTime
                    isStarted = true
                }
            }
        }
        .onDisappear(){
            Task{
                await mediLiveActivity.removeActivity()
                try await spatial.soundStop()
                await MainActor.run { isStarted = false }
            }
        }
        .onChange(of: isStarted, { oldValue, newValue in
            if isStarted{
                Task{
                    do{
                        try await Task.sleep(for: .seconds(playTime))
                        if !isStarted{ return }
                        try await spatial.soundStop()
                        if health.haveAuthorization(){
                            let isSuccessful = await health.saveMindfulSession(startTime: startDate, endTime: Date())
                        }
                        await MainActor.run { paths.append(.finish(mediItem)) }
                        isStarted = false
                    }catch{
                        print("\(error) cancelled")
                    }
                }
            }
        })
        .toolbar(.hidden, for: .navigationBar)
    }
}
extension PlayingView{
    var setLiveActivity: some View{
        EmptyView().onChange(of: scene) { oldValue, newValue in
            if newValue == .inactive{
                Task{
                    await mediLiveActivity.createActivity(mediType: Medi(rawValue: mediItem.id)!, count: playTime)
                }
            }else if newValue == .active{
                let timeDiff = Date().timeIntervalSince(self.startDate)
                self.nowTime = playTime - Int(timeDiff)
            }
        }.onReceive(AppIntentManager.eventPublisher, perform: { _ in
            isStarted = false
            Task{
                await mediLiveActivity.removeActivity()
                try await spatial.soundStop()
            }
            dismiss()
        })
    }
}
