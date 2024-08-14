//
//  RecordChardView.swift
//  HueIn
//
//  Created by Greem on 8/2/24.
//

import SwiftUI
import Charts
import HueDesignSystem
import Health_Remind
import GreemSwiftPackage

struct HealthRecordChartView: View {
    @Binding var datas: [MediChartItem]
    @State var nowDate: Date?
    var body: some View {
        Chart(datas.indices, id: \.self) { idx in
            BarMark(
                x: .value("Day", datas[idx].date, unit: .day),
                y: .value("Mind Set",datas[idx].seconds),
                width: .automatic,
                height: .automatic,
                stacking: .standard
            ).foregroundStyle(.white.gradient).cornerRadius(8)
            if let nowDate{
                RuleMark(x: .value("Day", nowDate))
                    .foregroundStyle(.gray.opacity(0.35))
                    .zIndex(-10)
                    .annotation (
                        position: .top,
                        spacing: 4,
                        overflowResolution: .init(x: .fit,y:.disabled)
                    ){ value in
                        VStack{
                            let prevDate = Calendar.current.startOfDay(for: nowDate)
                            if let date = datas.first(where: { $0.date == prevDate}){
                                (Text("\(date.date.dayOfWeek()): ").font(.pretendard(weight: .thin, size: 16))
                                +
                                 Text(date.seconds.convertToHMS())
                                ).foregroundStyle(.white).padding(.all,4).padding(.horizontal,2)
                                    .background(.thinMaterial.opacity(0.2)).preferredColorScheme(.light).clipShape(RoundedRectangle(cornerRadius: 8))
                            }else{
                                Text("no date").font(.title).foregroundStyle(.black)
                            }
                        }
                    }
            }
        }.chartPlotStyle(content: { plotArea in
            plotArea.background(Color(hex: "#D6E3FC").opacity(0.1).clipShape(RoundedRectangle(cornerRadius: 12)))
        })
        .frame(height: 270)
        .chartLegend(position: .bottom,alignment: .leading)
        .chartXSelection(value: $nowDate)
        .chartXAxis {
            AxisMarks(preset: .aligned,position: .bottom,values: .stride(by: .day,count:1)) { value in
                if let dateValue = value.as(Date.self){
                    AxisValueLabel(dateValue.dayOfWeek(type: .short), centered: true).font(.pretendard(weight: .medium, size: 15)).offset(y:4)
                }
            }
        }.chartYAxis {
            AxisMarks(preset:.aligned,position: .trailing) { value in
                if let timeValue = value.as(Int.self){
                    AxisValueLabel( timeValue.convertToHMS(),centered: true).font(.pretendard(weight: .medium, size: 12)).offset(x:4)
                        .foregroundStyle(.white)
                }
            }
        }
    }
}

