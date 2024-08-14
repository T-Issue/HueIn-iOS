//
//  FinishView.swift
//  HueIn
//
//  Created by Greem on 8/1/24.
//

import SwiftUI
import HueViews
import HueDesignSystem
import Health_Remind

struct FinishView: View{
    @Binding var paths:[StackViewType]
    @Environment(\.navigationControllerState) var naviState
    @Environment(\.health) var health
    @State private var todaySeconds: Int = 0
    @State private var showCharts:Bool = false
    @State private var userDenied:Bool = false
    @Environment(\.scenePhase) var scenePhase
    let mediItem: MediItem
    var body: some View{
        ZStack{
            Rectangle().fill().overlay {
                Image(.onboardBg).resizable().scaledToFill()
            }.overlay(content: {
                ZStack{
                    Image(mediItem.paths.pendingGradient).resizable()
                    Image(mediItem.paths.finishGraphic).resizable().scaledToFit()
                }.scaledToFill()
            }).ignoresSafeArea(.all)
            VStack{
                VStack(spacing:0){
                    MediAnalysisView(todaySeconds: $todaySeconds){
                        health.getAuthorization {
                            checkAuthrization()
                        } shown: {
                            checkAuthrization()
                        }
                    }.sheet(isPresented: $showCharts) {
                        FinishHealthRecordView()
                                .presentationBackground(.clear)
                                .presentationDragIndicator(.visible)
                                .background(Color(hex: "#787E95").opacity(0.6))
                                .background(.thinMaterial.opacity(0.95))
                                .preferredColorScheme(.dark)
                                .presentationDetents([.height(500)])
                                .presentationCornerRadius(30)
                    }
                    .alert("You already denied authorization to get health data", isPresented: $userDenied) {
                        Button(role: .cancel) { userDenied = false } label: {
                            Text("취소")
                        }
                        Button(role: nil) {
                            health.openHealthApp()
                            userDenied = false
                        } label: {
                            Text("접근 허가")
                        }
                    }
                    ExplainView(medi: mediItem)
                }
            }.offset(y:80)
            VStack {
                Spacer()
                HueViews.HueButton.Finish {
                    paths.removeAll()
                }.frame(height: 66).padding(.horizontal,20).padding(.bottom,32)
            }
        }
        .setNaviState(naviState: naviState)
        .toolbar(.hidden, for: .navigationBar)
    }
    func checkAuthrization(){
        if health.haveAuthorization(){
            showCharts = true
            userDenied = false
        }else {
            userDenied = true
            showCharts = false
        }
    }
}

fileprivate extension View{
    func setNaviState(naviState: any UINavigationControllerState ) -> some View{
        self.onAppear(){
            Task{
                try await Task.sleep(nanoseconds:100)
                await MainActor.run { naviState.allowsSwipeBack = false }
            }
        }.onDisappear(){ naviState.allowsSwipeBack = true }
    }
}


#Preview {
    @State var paths:[StackViewType] = []
    return FinishView(paths: $paths, mediItem: Medi.confidence.item)
}
