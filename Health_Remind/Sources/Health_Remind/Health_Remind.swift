// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

public struct HealthEnvironmentKey : EnvironmentKey{
    public static var defaultValue: HealthKitService = HealthKitManager.shared
}
public extension EnvironmentValues{
    var health: HealthKitService {
        get{ self[HealthEnvironmentKey.self] }
        set{ self[HealthEnvironmentKey.self] = newValue }
    }
}
