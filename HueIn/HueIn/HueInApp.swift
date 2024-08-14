//
//  HueInApp.swift
//  HueIn
//
//  Created by Greem on 7/31/24.
//

import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct HueInApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @MainActor @AppStorage(Labels.onboard) var isOnboard = false
    @State private var isSplash = true
    @Environment(\.mediLiveActivity) var mediLiveActivity
    @Environment(\.store) var store
    @Environment(\.scenePhase) var scene
    var body: some Scene {
        WindowGroup {
            ZStack{
                if isSplash{
                    Image(.onboardBg).resizable().ignoresSafeArea(.all)
                    LottieView(fileName: "Splash", loopMode: .playOnce).offset(y: -48).scaleEffect(CGSize(width: 1.0, height: 1.0))
                }else{
                    Group{
                        if !isOnboard{
                            OnboardingView(onboard: $isOnboard)
                        }else{
                            ListView().onAppear{
                                
                            }
                        }
                    }.animation(.linear(duration: 0.5), value: isOnboard)
                }
            }.animation(.linear(duration: 0.5), value: isSplash)
            .onAppear {
                Task{
                    await mediLiveActivity.removeActivity()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        isSplash = false
                    }
                }
            }.loadHueFontSystem()
        }
    }
}
enum StackViewType: Hashable,Equatable{
    var id: String{
        UUID().uuidString
    }
    case list
    case beforePlaying(MediItem)
    case playing(MediItem,Int)
    case finish(MediItem)
    case setting
    case settingDetail(SettingType)
    enum SettingType{
        case spatialAudio
        case health
    }
}
