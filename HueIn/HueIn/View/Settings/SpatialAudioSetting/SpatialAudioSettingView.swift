//
//  SpatialAudioSettingView.swift
//  HueIn
//
//  Created by Greem on 8/2/24.
//

import SwiftUI
import HueViews
import CoreGraphics
import simd
import Combine

struct SpatialAudioSettingView: View {
    @StateObject var vm: SpatialAudioSettingVM = .init()
    @Binding var paths: [StackViewType]
    @Environment(\.navigationControllerState) var naviState
    @Environment(\.dismiss) var dismiss
    @Environment(\.spatialAudio) var spatials
    @Environment(\.scenePhase) var scene
    var body: some View {
        ZStack{
            Rectangle().fill().overlay {
                    Image(.onboardBg).resizable().scaledToFill()
                }.ignoresSafeArea(.all)
            VStack(spacing: 0){
                InfoView().padding(.top,29)
                Spacer()
                MoveAudioView().environmentObject(vm)
                Spacer()
                VStack(spacing: 50){
                    Button{ vm.reset() }label: {
                        Text("RESET").foregroundStyle(.white).underline().font(.pretendard(weight: .regular, size: 16))
                    }.allowsHitTesting(!vm.isLoading)
                    HStack(alignment: .center, spacing:20){
                        Button { } label: {
                            Text("BACK").font(.montserrat(size: 20)).padding(.all,21)
                                .pressBorder()
                                .foregroundStyle(.white)
                                .background(.regularMaterial.opacity(0.2))
                                .clipShape(Capsule())
                        }.hueBtnStyle{
                            Task{ try await spatials.settingStop() }
                            dismiss()
                        }
                        HueViews.HueButton.Start(text: "Save setting",isActive: true, action: {
                            vm.saveSetting { self.dismiss() }
                        })
                        .transition(.opacity)
                    }.allowsHitTesting(!vm.isLoading)
                    .frame(height: 67).padding(.bottom,32).padding(.horizontal,20)
                }
            }
        }
        .onAppear(){ vm.spatial = spatials }
        .toolbar(.hidden, for: .navigationBar).onAppear(){
            naviState.allowsSwipeBack = false
        }
    }
}
