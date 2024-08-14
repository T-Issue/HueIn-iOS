//
//  SpatialEnvironment.swift
//  HueIn
//
//  Created by Greem on 8/2/24.
//

import SwiftUI
import Combine
struct Position:Codable{
    let x: Double
    let y: Double
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.x, forKey: .x)
        try container.encode(self.y, forKey: .y)
    }
}

struct SpatialKey : EnvironmentKey{
    static var defaultValue: SpatialState = SpatialStateImpl.shared
}
extension EnvironmentValues{
    var spatialAudio: SpatialState{
        get{ self[SpatialKey.self] }
        set{ self[SpatialKey.self] = newValue }
    }
    
}
protocol SpatialState:NSObject{
    var leftPosition : Size2D { get set}
    var rightPosition : Size2D { get set }
    func engineStart()
    
    func settingStart() async throws
    func settingStop() async throws
    func settingPause() async throws
    func settingResume() async throws
    
    
    func soundReady(leftPath: String,rightPath:String, format: String) async throws
    func soundStart() async throws
    func soundStart(leftPath: String,rightPath:String, format: String) async throws
    func soundStop() async throws
    func getNodePostion(sideType:SideType) -> Size2D
    func setNodePosition(sideType:SideType,position:Size2D)
    func saveNodePosition()
    func getNodePosition()->(left:Size2D,right:Size2D)
}
