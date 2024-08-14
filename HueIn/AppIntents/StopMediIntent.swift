//
//  StopMediIntent.swift
//  HueIn
//
//  Created by Greem on 8/13/24.
//

import Foundation
import AppIntents
import ActivityKit

struct StopMediIntent: LiveActivityIntent{
    static var title: LocalizedStringResource = "StopMediIntent"
    static var description: IntentDescription? = IntentDescription("Stop Meditation")
    func perform() async throws -> some IntentResult {
        AppIntentManager.stopMeditation()
        return .result()
    }
}
