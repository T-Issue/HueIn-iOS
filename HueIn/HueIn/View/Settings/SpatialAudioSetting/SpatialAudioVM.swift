//
//  SpatialAudioVM.swift
//  HueIn
//
//  Created by Greem on 8/2/24.
//

import Foundation

final class SpatialAudioSettingVM: ObservableObject{
    @Published var leftPosition: CGSize = .zero
    @Published var leftAccPositon: CGSize = .zero
    @Published var rightPosition: CGSize = .zero
    @Published var rightAccPosition: CGSize = .zero
    @Published var isLoading: Bool = true
    @Published var nowWidth: CGFloat = .zero
    weak var spatial : (any SpatialState)!
    deinit{ print("뷰 모델은 사라진다!") }
    func setAcc(type: SideType,position: CGSize){
        switch type{
        case .left: self.leftAccPositon = position
        case .right: self.rightAccPosition = position
        }
    }
    func set(type: SideType, position: Size2D){
        let radius = nowWidth / 2
        switch type{
        case .left: 
            self.leftPosition = position.convertToCGSize
            self.spatial.leftPosition = position / Float(radius) * 5
        case .right:
            self.rightPosition = position.convertToCGSize
            self.spatial.rightPosition = position / Float(radius) * 5
        }
    }
    private func setPosition(left leftP:Size2D,right rightP:Size2D){
        self.leftPosition = leftP.convertToCGSize
        self.leftAccPositon = leftP.convertToCGSize
        self.rightPosition = rightP.convertToCGSize
        self.rightAccPosition = rightP.convertToCGSize
    }
    func start(){
        let position = spatial.getNodePosition()
        spatial.leftPosition = position.left
        spatial.rightPosition = position.right
        let radius = nowWidth / 2
        let leftP = position.left * Float(radius) / 5
        let rightP = position.right * Float(radius) / 5
        setPosition(left: leftP, right: rightP)
    }
    func reset(){
        let positionX = Size2D(2,0)
        spatial.leftPosition = -positionX
        spatial.rightPosition = positionX
        let radius = nowWidth / 2
        let leftP = -positionX * Float(radius) / 5
        let rightP = positionX * Float(radius) / 5
        setPosition(left: leftP, right: rightP)
    }
    func saveSetting(completion:(()->())? = nil){
        spatial.saveNodePosition()
        Task{
            try await spatial.settingStop()
            await MainActor.run {
                completion?()
            }
        }
    }
}
