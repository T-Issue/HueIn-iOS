//
//  MediAnalysisView.swift
//  HueIn
//
//  Created by Greem on 8/1/24.
//

import SwiftUI

extension FinishView{
    struct MediAnalysisView: View {
        @Binding var todaySeconds: Int
        @Environment(\.health) var health
        @Environment(\.scenePhase) var scenePhase
        var action:(()->())?
        var body: some View {
            Button{
                action?()
            }label:{
                HStack(spacing:0) {
                    Text("Today").padding(.leading,25).foregroundStyle(Color.desc)
                    Spacer()
                    Text("\(todaySeconds / 60)m \(todaySeconds % 60)s").foregroundStyle(.white)
                    Spacer()
                    Image(systemName: "chevron.down").font(.system(size: 20))
                        .padding(.trailing,12).foregroundStyle(.white)
                }.font(.pretendard(weight: .regular, size: 22))
                    .frame(width: 260,height: 44)
                    .background(.thinMaterial.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.bottom,22).padding(.top,47)
                    .onAppear(){
                        updateTodaySeconds()
                    }
            }.onChange(of: scenePhase, perform: {  newValue in
                if newValue == .active{
                    let go = { self.todaySeconds = 0 }
                     health.haveAuthorization() ? updateTodaySeconds(): go()
                }
            })
        }
        func updateTodaySeconds(){
            Task{
                do{
                    let seconds:Int = try await health.todayTotalSeconds()
                    await MainActor.run {
                        self.todaySeconds = seconds
                    }
                }catch{
                    print(error)
                }
            }
        }
    }
}
