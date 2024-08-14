//
//  OnboardingView.swift
//  HueIn
//
//  Created by Greem on 7/31/24.
//

import SwiftUI
import HueViews

struct OnboardingView:View {
    @State private var selection:Int = 0
    @Binding var onboard:Bool
    @State var getStarted:Bool = false
    @Environment(\.health) var health
    @State private var loading:Bool = false
    var body: some View {
        NavigationStack {
            ZStack{
                Rectangle().fill().overlay {
                    Image(.onboardBg).resizable().scaledToFill()
                    }.ignoresSafeArea(.all)
                if selection <= 1 {
                    VStack{
                        tabView
                        tabButton
                    }
                }
                if loading{
                    LoadingView()
                }
            }.toolbar(.hidden, for: .navigationBar)
                .navigationDestination(isPresented: $getStarted) {
                    OnboardSettingSpatial(onboard: $onboard)
                }
        }
        
//        .sheet(isPresented: $getStarted, onDismiss: {
//            onboard.toggle()
//        }, content: {
//            OnboardSettingSpatial()
//                .background(.ultraThinMaterial)
//                .presentationBackground(.clear)
//                .interactiveDismissDisabled()
//                .preferredColorScheme(.dark)
//        })
    }
}

fileprivate extension OnboardingView{
    @ViewBuilder var tabView: some View{
        TabView(selection: $selection.animation(.linear)) {
            OnboardHelpInfo().tag(0)
//            OnboardShareCar(isShown: $selection).tag(1)
            OnboardBinaural(isShown: $selection).tag(1)
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
    }
    @ViewBuilder var tabButton: some View{
        Group{
            if selection != 1{
                HueViews.HueButton.Next(action: {
                    withAnimation { selection += 1 }
                })
            }else{
                HueViews.HueButton.Start(isActive: true) {
                    selection += 1
                    loading = true
                    let completionAction = {
                        loading = false
                        getStarted = true
                    }
                    if health.isHealthKitAvailable(){
                        health.getAuthorization(first: completionAction, shown: completionAction)
                    }else{
                        getStarted = true
                    }
                }
            }
        }.transition(.opacity).frame(height: 66).padding(.horizontal,20).padding(.bottom,32)
    }
}

#Preview {
    OnboardingView(onboard: .constant(true))
}
