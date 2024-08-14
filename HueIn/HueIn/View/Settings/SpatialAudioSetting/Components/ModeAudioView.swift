//
//  ModeAudioView.swift
//  HueIn
//
//  Created by Greem on 8/2/24.
//

import SwiftUI

extension SpatialAudioSettingView{
    struct MoveAudioView:View {
        @Environment(\.spatialAudio) var spatials
        @Environment(\.scenePhase) var scene
        @EnvironmentObject var vm: SpatialAudioSettingVM
        let circleRadius:CGFloat = 18
        var clampDistance: Float{ (Float(vm.nowWidth) / 2) - Float(circleRadius) }
        @State private var showCircle = false
        var body: some View {
            ZStack{
                GeometryReader { proxy in
                    Color.clear.onAppear(){
                        Task{
                            try await Task.sleep(nanoseconds: 1000)
                            let size = proxy.size.width
                            await MainActor.run {
                                vm.nowWidth = size
                            }
                        }
                    }.padding(.horizontal,12)
                }
                Group{
                    if vm.isLoading{
                        LoadingView()
                    }else{
                        spatialView
                    }
                }.onAppear(){
                    Task{
                        do{
                            try await Task.sleep(for: .seconds(0.666))
                            spatials.engineStart()
                            await MainActor.run { vm.start() }
                            try await spatials.settingStart()
                            await MainActor.run {
                                print("Lazy 하지 않음!!")
                                withAnimation { 
                                    showCircle = true
                                    vm.isLoading = false
                                }
                            }
                        }catch{
                            print("spatial setting error")
                            print(error)
                        }
                    }
                }
            }.onChange(of: scene) { oldValue, newValue in
                if newValue == .active{
                    Task{ try await spatials.settingStart() }
                }else if newValue == .inactive{
                    Task{
                        try await spatials.settingPause()
                    }
                }
            }
        }
        var spatialView: some View{
            Image(.spatialBg).resizable().aspectRatio(contentMode: .fit)
                .frame(width: vm.nowWidth,height: vm.nowWidth)
                .overlay {
                    leftCircle.opacity(showCircle ? 1 : 0)
                }.overlay {
                    rightCircle.opacity(showCircle ? 1 : 0)
                }.frame(width: vm.nowWidth,height: vm.nowWidth)
        }
    }
    
}

extension SpatialAudioSettingView.MoveAudioView{
    var leftCircle: some View{
        Circle().fill(Color(hex: "#7858EC"))
            .overlay(content: {
                Text("L").font(.hue.h1).foregroundStyle(.white)
            })
            .offset(vm.leftPosition)
            .frame(width: circleRadius * 2,height: circleRadius * 2)
            .gesture(DragGesture().onChanged({ value in
                let simdTranslation:Size2D = value.translation.convertToSIMD
                let simdAcc:Size2D = vm.leftAccPositon.convertToSIMD
                let simdPosition:Size2D = (simdTranslation + simdAcc).circularClamp(abs: clampDistance)
                vm.set(type: .left, position: simdPosition)
            }).onEnded({ gesture in
                vm.setAcc(type: .left, position: vm.leftAccPositon + gesture.translation)
            })).frame(width: vm.nowWidth,height: vm.nowWidth)
            .clipped()
    }
    var rightCircle: some View{
        Circle().fill(Color(hex: "#97EECB"))
            .overlay(content: {
                Text("R").font(.hue.h1).foregroundStyle(.white)
            })
            .offset(vm.rightPosition)
            .frame(width: circleRadius * 2,height: circleRadius * 2)
            .gesture(DragGesture().onChanged({ value in
                let simdTranslation:Size2D = value.translation.convertToSIMD
                let simdAcc:Size2D = vm.rightAccPosition.convertToSIMD
                let simdPosition:Size2D = (simdTranslation + simdAcc).circularClamp(abs: clampDistance)
                vm.set(type: .right, position: simdPosition)
            }).onEnded({ gesture in
                vm.setAcc(type: .right, position: vm.rightAccPosition + gesture.translation)
            })
            ).frame(width: vm.nowWidth,height: vm.nowWidth)
            .clipped()
    }
}
