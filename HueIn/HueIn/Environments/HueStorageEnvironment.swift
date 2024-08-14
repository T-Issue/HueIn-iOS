//
//  HueStorage.swift
//  HueIn
//
//  Created by Greem on 8/1/24.
//

import SwiftUI
import Combine
//HueStorageEnvironment
struct HueStorageKey : EnvironmentKey{
    static var defaultValue: HueStorageState = HueStorageImpl.shared
}
extension EnvironmentValues{
    var hueStorage: HueStorageState{
        get{ self[HueStorageKey.self] }
        set{ self[HueStorageKey.self] = newValue }
    }
}
protocol HueStorageState:NSObject{
    var mediItems:[Medi : MediItem] { get }
    var likedMedis:Set<Medi>{ get throws }
    func update(likedMedis:Set<Medi>) throws
}

final class HueStorageImpl: NSObject, HueStorageState{
    fileprivate static let shared = HueStorageImpl()
    lazy var mediItems: [Medi : MediItem] = Medi.allCases.reduce(into: [:], {$0[$1] = $1.item})
    var likedMedis:Set<Medi>{
        get throws{
            guard let data = UserDefaults.standard.data(forKey: "LikedMedis") else { return [] }
            let mediItems = try JSONDecoder().decode([Medi.ID].self, from: data)
            return Set(mediItems.map{Medi(rawValue: $0)!})
        }
    }
    func update(likedMedis:Set<Medi>) throws {
        let data = try JSONEncoder().encode(likedMedis.map{$0.id})
        UserDefaults.standard.setValue(data, forKey: "LikedMedis")
    }
}
