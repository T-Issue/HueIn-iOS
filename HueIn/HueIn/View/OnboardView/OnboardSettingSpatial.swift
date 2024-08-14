//
//  SettingSpatial.swift
//  HueIn
//
//  Created by Greem on 7/31/24.
//

import SwiftUI
import HueViews
import HueDesignSystem

struct OnboardSettingSpatial: View {
    @Binding var onboard: Bool
    @Environment(\.dismiss) var dismiss
    @Environment(\.navigationControllerState) var naviState
    @State private var accessNoiseSheet = false
    @Environment(\.spatialAudio) var spatials
    @State private var isMute = false
    @StateObject var vm: SpatialAudioSettingVM = .init()
    var body: some View {
        NavigationStack {
            ZStack{
                Rectangle().fill().overlay {
                        Image(.onboardBg).resizable().scaledToFill()
                    }.ignoresSafeArea(.all)
                VStack(spacing: 0){
                    SpatialAudioSettingView.InfoView().padding(.top,29)
                    Spacer()
                    SpatialAudioSettingView.MoveAudioView().environmentObject(vm)
                    Spacer()
                    VStack(spacing: 50){
                        Button{
                            vm.reset()
                        }label: {
                            Text("RESET").foregroundStyle(.white).underline().font(.pretendard(weight: .regular, size: 16))
                        }
                        HStack(alignment: .center, spacing:20){
                            Button { } label: {
                                Text("SKIP").font(.montserrat(size: 20)).padding(.all,21)
                                    .pressBorder()
                                    .foregroundStyle(.white)
                                    .background(.regularMaterial.opacity(0.2))
                                    .clipShape(Capsule())
                            }.hueBtnStyle{
                                Task{                             
                                    try await spatials.settingStop()
                                    await MainActor.run {
                                        onboard = true
                                    }
                                }
                            }
                            HueViews.HueButton.Start(text: "Save setting",isActive: true, action: {
                                vm.saveSetting {
                                    Task{
                                        await MainActor.run {
                                            onboard = true
                                        }
                                    }
                                }
                            })
                        }
                        .allowsHitTesting(!vm.isLoading)
                        .frame(height: 67).padding(.bottom,32).padding(.horizontal,20)
                    }
                }
            }.toolbar(.hidden, for: .navigationBar)
            .onAppear(){
                vm.spatial = spatials
                naviState.allowsSwipeBack = false
            }
        }
        
    }
}
