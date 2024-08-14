//
//  SettingMediItemView.swift
//  HueIn
//
//  Created by Greem on 8/2/24.
//

import SwiftUI
extension SettingView{
    struct RecentLikedMediView: View {
        @State private var likedMedis: [MediItem] = []
        @Binding var paths:[StackViewType]
        @Environment(\.hueStorage) var hueStorage
        var body: some View {
            Section {
                ScrollView(.horizontal) {
                    HStack{
                        ForEach(likedMedis,id:\.self){ medi in
                            SettingMediItemView(mediItem: medi, action: { item in
                                paths.append(.beforePlaying(item))
                            })
                        }
                    }
                }.scrollIndicators(.hidden)
            } header: {
                HStack{
                    Text("MY FAVORITES >").font(.pretendard(weight: .medium, size: 16))
                        .frame(height: 40).foregroundStyle(.white)
                    Spacer()
                }
            }.padding(.leading,16)
            .onAppear(){
                Task{
                    do{
                        let medis = try hueStorage.likedMedis
                        self.likedMedis = medis.map{$0.item}
                    }catch{
                        print(error)
                    }
                }
            }
        }
    }
    struct SettingMediItemView: View {
        let mediItem:MediItem
        var action:(MediItem)->()
        var body: some View {
            Button{
                action(mediItem)
            }label: {
                VStack(content: {
                    Image(mediItem.paths.thumbnail).resizable().scaledToFit().frame(width: 76,height: 76)
                    Text(mediItem.title).font(.montserrat(size: 14)).foregroundStyle(.white)
                }).frame(width: 120,height: 120)
                    .background(.regularMaterial.opacity(0.33),in: RoundedRectangle(cornerRadius: 15))
                    .overlay(content: {
                        RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 1).foregroundStyle(.white.opacity(0.5))
                    })
                    .clipShape(RoundedRectangle(cornerRadius: 15,style: .circular))
                    .environment(\.colorScheme, .light)
            }
            
        }
    }
}
