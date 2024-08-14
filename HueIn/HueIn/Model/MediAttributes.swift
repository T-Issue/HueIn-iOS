//
//  MediAttributes.swift
//  HueIn
//
//  Created by Greem on 8/5/24.
//

import Foundation
import ActivityKit

struct MediAttributes: ActivityAttributes{
    struct ContentState: Codable, Hashable{
        var mediType: Medi = .concentrate
        var restCount = 0
        var count:Int = 0
        var startDate:Date = Date()
    }
}
