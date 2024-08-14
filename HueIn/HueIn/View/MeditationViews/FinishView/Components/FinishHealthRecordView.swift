//
//  RecordChardView.swift
//  HueInDesign
//
//  Created by Greem on 7/30/24.
//

import SwiftUI
import Charts
import HueDesignSystem
import Health_Remind
import GreemSwiftPackage

struct FinishHealthRecordView:View {
    @Environment(\.health) var health
    @State var chartDatas:[MediChartItem] = []
    var body: some View {
        VStack (spacing: 16){
            VStack(spacing: 8){
                Text("Mindfulness time").font(.hue.h1).foregroundStyle(.white).frame(height: 30)
                Text(getDurationDesc()).foregroundStyle(Color.desc).frame(height: 24)
            }
            Spacer()
            HealthRecordChartView(datas: $chartDatas).frame(height: 270)
            Spacer()
            Button{
                health.openHealthApp()
            }label: {
                Text("More").font(.hue.body).foregroundStyle(.white).underline()
            }
            Spacer()
        }
        .padding(.top,40)
        .padding(.horizontal,22)
        .onAppear(){
            Task{
                do{
                    let arr = try await MediChartItem.getLast7DaysItems(health: health)
                    await MainActor.run { chartDatas = arr }
                }catch{
                    print(error)
                }
            }
        }
    }
    func getDurationDesc()->String{
        guard let left = chartDatas.first?.date, let right = chartDatas.last?.date else {return ""}
        return "\(left.formatDateToString()) - \(right.formatDateToString())"
    }
    
}


#Preview(body: {
    FinishHealthRecordView()
})


