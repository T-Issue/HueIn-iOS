//
//  MediItem.swift
//  HueIn
//
//  Created by Greem on 8/1/24.
//

import Foundation
enum Medi:String, Identifiable,CaseIterable,Codable{
    var id:String{ self.rawValue }
    case free
    case happy
    case destress
    case concentrate
    case confidence
    var item: MediItem{
        switch self {
        case .free:
            let before = "\"Find inner freedom and experience deep peace\""
            let after = "\"May it be a day where you clear your mind\nand fill it with gratitude and happiness.\""
            return MediItem(id: self.id, title: "Feel Free", afterTitle: "Full of freedom",
                            desc: "When I want to feel free and liberated",
                            beforeInfo: before,afterInfo: after,
                            paths: self.resourcePath)
        case .happy:
            let before = "\"Be grateful in every moment,\nand fill each moment with happiness\""
            let after = "\"May you have a day filled with gratitude and\nhappiness as you empty your mind.\""
            return MediItem(id: self.id, title: "Be happy", afterTitle: "Full of gratitude Happiness", desc: "When I want gratitude and happiness",beforeInfo: before ,afterInfo: after, paths: self.resourcePath)
        case .destress:
            let before = "\"Take a deep breath and let the stress go\""
            let after = "\"Let go of your stress and find your way back\nto a sense of calm and relaxation.\""
            return MediItem(id: self.id, title: "Destress", afterTitle: "clearer and  refreshed", desc: "When i want to relieve stress",beforeInfo: before,afterInfo: after,
                            paths: resourcePath)
        case .concentrate:
            let before = "\"Feel your breath and find peace and\nfocus for your mind.\""
            let after = "\"Take a calm breath and focus on today's goal.\""
            return MediItem(id: self.id, title: "Concentrate", afterTitle: "Discover your balance", desc: "when i need focus and calm breathing",beforeInfo: before,afterInfo: after,
                     paths: resourcePath)
        case .confidence:
            let before = "\"Calm your mind and cultivate belief in yourself.\""
            let after = "\"With a deep breath, trust yourself,\nand confidently face the day.\""
            return MediItem(id: self.id, title: "Confidence", afterTitle: "even clearer and  refreshed", desc: "when you need confidence",beforeInfo: before,afterInfo: after,paths: resourcePath)
        }
    }
    private var resourcePath: MediResourcePaths{
        switch self {
        case .free:
            MediResourcePaths(id: self.id, thumbnail: "Graphic_Feelfree", pendingGradient: "BackgroundFree", playingGraphic: "feelFree", finishGraphic: "FreeShadow",leftSound: "feelfree_L",rightSound: "feelfree_R")
        case .happy:
            MediResourcePaths(id: self.id, thumbnail: "Graphic_Behappy", pendingGradient: "BackgroundHappiness", playingGraphic: "BeHappy", finishGraphic: "HappinessShadow",leftSound: "behappy_L",rightSound: "behappy_R")
        case .destress:
            MediResourcePaths(id: self.id, thumbnail: "Graphic_Destress", pendingGradient: "BackgroundDestress", playingGraphic: "Destress", finishGraphic: "DestressShadow",leftSound: "destress_L",rightSound: "destress_R")
        case .concentrate:
            MediResourcePaths(id: self.id, thumbnail: "Graphic_Concentrate", pendingGradient: "BackgroundConcentrate", playingGraphic: "Concentrate", finishGraphic: "ConcentrateShadow",leftSound: "concentrate_L",rightSound: "concentrate_R")
        case .confidence:
            MediResourcePaths(id: self.id, thumbnail: "Graphic_Confidence", pendingGradient: "BackgroundConfidence", playingGraphic: "Confidence", finishGraphic: "ConfienceShadow",leftSound: "confidence_L",rightSound: "confidence_R")
        }
    }
}
struct MediItem:Identifiable,Hashable,Codable{
    let id:String
    let title:String
    let afterTitle:String
    let desc:String
    let beforeInfo: String
    let afterInfo: String
    let paths: MediResourcePaths
}

struct MediResourcePaths:Identifiable,Hashable,Codable{
    let id:String
    let thumbnail:String
    let pendingGradient: String
    let playingGraphic:String
    let finishGraphic:String
    let leftSound:String
    let rightSound:String
}
