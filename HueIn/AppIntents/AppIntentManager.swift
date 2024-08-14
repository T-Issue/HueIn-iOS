//
//  AppIntentManager'.swift
//  HueIn
//
//  Created by Greem on 8/13/24.
//

import Foundation
import AppIntents
import ActivityKit
import Combine

enum AppIntentManager{
    static let appGroup = "com.tistory.arpple.HueIn.liveActivity"
    static let defaults = UserDefaults(suiteName: appGroup)
    static private let keyName = "activityIntent"
    static private let _eventPublisher: PassthroughSubject<(),Never> = .init()
    static var eventPublisher: AnyPublisher<(),Never>{ _eventPublisher.eraseToAnyPublisher() }
    
    static func stopMeditation(){
        Task{@MainActor in _eventPublisher.send(()) }
    }
}
