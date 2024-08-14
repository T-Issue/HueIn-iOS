//
//  SettingHealthSelectionView.swift
//  HueIn
//
//  Created by Greem on 8/2/24.
//

import SwiftUI
import HueViews
import HueDesignSystem
import Health_Remind

extension SettingView{
    struct HealthSelectionView: View {
        @State private var chartItems:[MediChartItem] = []
        @Environment(\.health) var health
        @State private var isHeathToggle:Bool = false
        @State private var healthSectionExpandable:Bool = true
        @Environment(\.scenePhase) var scenePhase
        var body: some View {
            VStack(spacing: 13){
                VStack(alignment:.leading,spacing:8){
                    VStack(alignment: .leading,spacing: 8){
                        HStack{
                            Text("Connect Apple Health").font(.system(size: 16,weight: .medium))
                                .foregroundStyle(.white)
                            Spacer()
                            Button{
                                withAnimation{
                                    self.healthSectionExpandable.toggle()
                                }
                            }label: {
                                Image(systemName: "chevron.right").foregroundStyle(.white).rotationEffect(.degrees(healthSectionExpandable ? 90 : 0))
                            }
                        }
                        Text("Monitor your fitness and heath goals with Apple Health.").font(.system(size: 12,weight: .medium)).foregroundStyle(Color.desc)
                    }
                    if healthSectionExpandable {
                        if isHeathToggle{
                            HealthRecordChartView(datas: $chartItems, nowDate: Date())
                                .padding([.leading,.bottom])
                                .padding(.top,40)
                                .background(.thinMaterial.opacity(0.66))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .onAppear(){
                                    Task{
                                        do{
                                            let chartItems = try await MediChartItem.getLast7DaysItems(health: health)
                                            await MainActor.run {
                                                self.chartItems = chartItems
                                            }
                                        }catch{
                                            print("Setting Health Error \(error)")
                                        }
                                    }
                                }
                        }else{
                            Button{health.openHealthApp()}label: {
                                Text("Go to fitness App and authorizing").foregroundStyle(.white)
                            }
                        }
                    }
                }
                Divider().background(.white.opacity(0.3)).frame(height: 1)
            }.padding(.horizontal,20).onAppear(){
                updateHealthAuthorization()
            }
            .onChange(of: scenePhase) { oldValue, newValue in
                if newValue == .active{
                    updateHealthAuthorization()
                }
            }
        }
        func updateHealthAuthorization(){
            Task{@MainActor in
                health.getAuthorization {
                    isHeathToggle = health.haveAuthorization()
                } shown: {
                    isHeathToggle = health.haveAuthorization()
                }
            }
        }
    }
}
