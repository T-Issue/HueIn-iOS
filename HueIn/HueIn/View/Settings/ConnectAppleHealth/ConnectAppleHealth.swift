//
//  ConnectAppleHealth.swift
//  HueIn
//
//  Created by Greem on 8/4/24.
//

import SwiftUI
import HueViews
import HueDesignSystem

struct ConnectAppleHealth: View {
    @Binding var paths: [StackViewType]
    @Environment(\.scenePhase) var scene
    @Environment(\.health) var health
    @State private var chartItems:[MediChartItem] = []
    @State private var isHeathToggle:Bool = false
    @State private var isLoading:Bool = true
    var body: some View {
        ZStack{
            Rectangle().fill().overlay {
                Image(.onboardBg).resizable().scaledToFill()
            }.ignoresSafeArea(.all)
            VStack(spacing: 0) {
                SettingView.SettingNavigationView().padding([.horizontal,.bottom],16)
                if isHeathToggle{
                    if isLoading{
                        LoadingView()
                    }else{
                        healthAvailableView
                    }
                }else{
                    HealthUnAvailabeView().padding(.horizontal,16)
                }
                Spacer()
                HueViews.HueButton.Start(text: "\(isHeathToggle ? "Look at" : "Setting at") Apple Health",isActive: true) {
                    health.openHealthApp()
                }.frame(height: 67).padding(.vertical,30).padding(.horizontal,20)
            }.onAppear(){
                health.getAuthorization {
                    self.isHeathToggle = health.haveAuthorization()
                } shown: {
                    self.isHeathToggle = health.haveAuthorization()
                }
                isLoading = true
                Task{
                    do{
                        let chartItems = try await MediChartItem.getLast7DaysItems(health: health)
                        await MainActor.run {
                            self.chartItems = chartItems
                            self.isLoading = false
                        }
                    }catch{
                        print("Setting Health Error \(error)")
                    }
                }
            }
            .onChange(of: scene) { oldValue, newValue in
                if newValue == .active{
                    health.getAuthorization {
                        self.isHeathToggle = health.haveAuthorization()
                    } shown: {
                        self.isHeathToggle = health.haveAuthorization()
                    }
                    isLoading = true
                    Task{
                        do{
                            let chartItems = try await MediChartItem.getLast7DaysItems(health: health)
                            await MainActor.run {
                                self.chartItems = chartItems
                                isLoading = false
                            }
                        }catch{
                            print("Setting Health Error \(error)")
                        }
                    }
                }
            }
        }.toolbar(.hidden, for: .navigationBar)
    }
    func getDurationDesc()->String{
        guard let left = chartItems.first?.date, let right = chartItems.last?.date else {return ""}
        return "\(left.formatDateToString()) - \(right.formatDateToString())"
    }
}

extension ConnectAppleHealth{
    var healthAvailableView: some View{
        VStack(spacing: 16){
            VStack(spacing: 8){
                Text("Mindfulness time").font(.hue.h1).foregroundStyle(.white).frame(height: 30)
                Text(getDurationDesc()).foregroundStyle(Color.desc).frame(height: 24)
            }
            HealthRecordChartView(datas: $chartItems, nowDate: Date())
                .padding([.leading,.bottom])
                .padding(.trailing,8)
                .padding(.top,40)
                .background(.thinMaterial.opacity(0.66))
                .preferredColorScheme(.dark)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
        }
    }
}




#Preview {
    ConnectAppleHealth(paths: .constant([]))
}
