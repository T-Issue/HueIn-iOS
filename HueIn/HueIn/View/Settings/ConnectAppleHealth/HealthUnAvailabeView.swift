//
//  HealthUnAvailabeView.swift
//  HueIn
//
//  Created by Greem on 8/6/24.
//

import Foundation
import SwiftUI
import HueDesignSystem
import HueViews

extension ConnectAppleHealth{
    struct HealthUnAvailabeView: View {
        @State var selection = 0
        let guides:[ImageResource] = [.health1,.health2,.health3,.health4,.health5]
        @State var showGuideImage = false
        @Environment(\.dismiss) var dismiss
        var body: some View {
            VStack(content: {
                TabView(selection: $selection,
                        content:  {
                    ForEach(guides.indices,id:\.self){ idx in
                        VStack{
                            Image(guides[idx]).resizable().scaledToFit().clipShape(RoundedRectangle(cornerRadius: 20))
                                .tag(idx)
                                .onTapGesture {
                                    showGuideImage.toggle()
                                }
                            Spacer()
                        }
                    }
                })
                .tabViewStyle(.page(indexDisplayMode: .never))
                .fullScreenCover(isPresented: $showGuideImage, content: {
                    ZStack{
                        Image(guides[selection]).resizable().scaledToFill().background(.black).ignoresSafeArea(.all)
                        VStack(spacing: 0){
                            HStack(content: {
                                HueViews.HueButton.Close{ showGuideImage = false }
                                Spacer()
                            }).padding(.horizontal,16)
                            Spacer()
                        }
                    }
                })
                VStack(spacing:0){
                    HStack(content: {
                        ForEach(guides.indices,id: \.self){ idx in
                            Circle().fill(selection != idx ? .gray : .white).frame(width: 8,height: 8)
                        }
                    })
                    Spacer()
                    ForEach(guides.indices,id:\.self){ idx in
                        if idx == selection{
                            Text(guideDescriptiosn[idx]).font(.montserrat(size: 14)).multilineTextAlignment(.center).foregroundStyle(.white)
                                .transition(.opacity)
                                .opacity(idx == selection ? 1 : 0)
                                .animation(.easeInOut,value: selection)
                        }
                    }
                    Spacer()
                }.frame(height: 80)
            })
        }
    }
}
extension ConnectAppleHealth.HealthUnAvailabeView{
    var guideDescriptiosn:[String]{
        [
            "Please go to the health app category\nand find “Mental Wellbeing”.",
            "Go to “Mindful Minutes” in Mental Wellbeing page",
            "Options - Connect with “Data sources & access”",
            "Please allow “APPS AND SERVICES\n ALLOWED TO READ” that are allowed to\n read HueIn.",
            "Enable HueIn for your data source in edit\n mode"
        ]
    }
}
