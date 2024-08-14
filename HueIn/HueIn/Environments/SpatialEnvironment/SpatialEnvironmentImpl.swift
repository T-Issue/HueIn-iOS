//
//  SpatialEnvironmentImpl.swift
//  HueIn
//
//  Created by Greem on 8/2/24.
//

import AVFoundation
import CoreMotion
import AVFAudio
import simd
import Combine
typealias Size2D = SIMD2<Float>
enum SideType{
    case left
    case right
}
extension AVAudioPlayerNode{
    func set2DPosition(_ position:Size2D){
        self.position.x = position.x
        self.position.y = position.y
    }
}

@globalActor actor SpatialActor : GlobalActor {
    static let shared: SpatialActor = .init()
}

final class SpatialStateImpl: NSObject, SpatialState{
    
    static let shared = SpatialStateImpl()
    private let engine = AVAudioEngine()
    private let session = AVAudioSession.sharedInstance()
    private let environment = AVAudioEnvironmentNode()
    private var leftSettingSoundNode: AVAudioPlayerNode!
    private var rightSettingSoundNode: AVAudioPlayerNode!
    private var leftSoundNode:AVAudioPlayerNode!
    private var rightSoundNode:AVAudioPlayerNode!
    private var isUserSaved:Bool{
        get{ UserDefaults.standard.bool(forKey: "UserSaved") }
        set{ UserDefaults.standard.setValue(newValue, forKey: "UserSaved") }
    }
    var leftPosition: Size2D {
        get{ .init(leftSettingSoundNode.position.x, leftSettingSoundNode.position.y) }
        set{
            guard let leftSettingSoundNode else { return }
            leftSettingSoundNode.position.x = newValue.x
            leftSettingSoundNode.position.y = newValue.y
        }
    }
    var rightPosition: Size2D{
        get{ .init(rightSettingSoundNode.position.x, rightSettingSoundNode.position.y) }
        set{
            guard let rightSettingSoundNode else {return }
            rightSettingSoundNode.position.x = newValue.x
            rightSettingSoundNode.position.y = newValue.y
        }
    }
    
    private override init() {
        super.init()
        setupSession()
        environment.listenerPosition = AVAudio3DPoint(x: 0, y: 0, z: 0)
        environment.listenerAngularOrientation = AVAudioMake3DAngularOrientation(0.0, 0, 0)
        engine.attach(environment)
        leftSettingSoundNode = self.getNode(file: "behappy_L",withExtension: "mp3", atPosition: AVAudio3DPoint(x: -2, y: 0, z: 0))
        rightSettingSoundNode = self.getNode(file: "behappy_R", withExtension: "mp3", atPosition: .init(x: 2, y: 0, z: 0))
        engine.connect(environment, to: engine.mainMixerNode, format: nil)
        engine.prepare()
    }
    func engineStart(){
        try! engine.start()
    }
    func clearNodes(){
        [leftSoundNode,rightSoundNode,leftSettingSoundNode,rightSettingSoundNode].forEach { node in
            if let node{ engine.detach(node) }
        }
        leftSoundNode = nil;rightSoundNode = nil; leftSettingSoundNode = nil; rightSettingSoundNode = nil;
    }
    /// UserDefaults로 가져온 각각 소리의 위치에 맞게 설정 후 재생한다.
    func settingStart() async throws{
            clearNodes()
            if leftSettingSoundNode == nil && rightSettingSoundNode == nil{
                
                leftSettingSoundNode = self.getNode(file: "setting_L",withExtension: "mp3", atPosition: AVAudio3DPoint(x: 0, y: 0, z: 0))
                rightSettingSoundNode = self.getNode(file: "setting_R", withExtension: "mp3", atPosition: .init(x: 0, y: 0, z: 0))
            }
            let position = getNodePosition()
            setNodePosition(sideType: .left, position: position.left)
            setNodePosition(sideType: .right, position: position.right)
            try! engine.start()
            leftSettingSoundNode.play()
            rightSettingSoundNode.play()
            try await Task.sleep(nanoseconds: 1000)
            leftSettingSoundNode.volume = 1
            rightSettingSoundNode.volume = 1
        
    }
    func settingResume() async throws{
        guard let leftSettingSoundNode,let rightSettingSoundNode else { return }
        try engine.start()
        leftSettingSoundNode.play();rightSettingSoundNode.play()
    }
    func settingPause() async throws {
        guard let leftSettingSoundNode,let rightSettingSoundNode else { return }
        leftSettingSoundNode.pause();rightSettingSoundNode.pause()
        engine.pause()
    }
    func settingStop() async throws {
        guard let leftSettingSoundNode,let rightSettingSoundNode else { return }
        leftSettingSoundNode.volume = 0
        rightSettingSoundNode.volume = 0
        try await Task.sleep(nanoseconds: 1000)
        leftSettingSoundNode.stop()
        rightSettingSoundNode.stop()
        engine.stop()
        engine.detach(leftSettingSoundNode);engine.detach(rightSettingSoundNode);
        self.leftSettingSoundNode = nil; self.rightSettingSoundNode = nil
    }
    func getNodePostion(sideType:SideType) -> Size2D{
        switch sideType {
        case .left:
                .init(leftSettingSoundNode.position.x,leftSettingSoundNode.position.y)
        case .right:
                .init(rightSettingSoundNode.position.x,rightSettingSoundNode.position.y)
        }
    }
    func setNodePosition(sideType:SideType,position:Size2D){
        switch sideType{
        case .left:
            leftSettingSoundNode.position.x = position.x
            leftSettingSoundNode.position.y = position.y
        case .right:
            rightSettingSoundNode.position.x = position.x
            rightSettingSoundNode.position.y = position.y
        }
    }
    func getNodePosition()->(left:Size2D,right:Size2D){
        guard isUserSaved else { return (.init(-2,0),.init(2, 0)) }
        let leftX = UserDefaults.standard.float(forKey: Labels.leftSettingX)
        let leftY = UserDefaults.standard.float(forKey: Labels.leftSettingY)
        let rightX = UserDefaults.standard.float(forKey: Labels.rightSettingX)
        let rightY = UserDefaults.standard.float(forKey: Labels.rightSettingY)
        return (.init(leftX,leftY),.init(rightX, rightY))
    }
    func saveNodePosition(){
        isUserSaved = true
        UserDefaults.standard.setValue(leftSettingSoundNode.position.x, forKey: Labels.leftSettingX)
        UserDefaults.standard.setValue(leftSettingSoundNode.position.y, forKey: Labels.leftSettingY)
        UserDefaults.standard.setValue(rightSettingSoundNode.position.x, forKey: Labels.rightSettingX)
        UserDefaults.standard.setValue(rightSettingSoundNode.position.y, forKey: Labels.rightSettingY)
    }
    
    @SpatialActor func soundReady(leftPath:String, rightPath:String, format: String = "mp3") async throws{
        clearNodes()
        if leftSoundNode == nil && rightSoundNode == nil{
            leftSoundNode = self.getNode(file: leftPath,withExtension: format, atPosition: AVAudio3DPoint(x: 0, y: 0, z: 0))
            rightSoundNode = self.getNode(file: rightPath, withExtension: format, atPosition: .init(x: 0, y: 0, z: 0))
        }
        let position = getNodePosition()
        leftSoundNode.set2DPosition(position.left)
        rightSoundNode.set2DPosition(position.right)
        engine.prepare()
    }
    @SpatialActor func soundStart() async throws {
        guard let leftSoundNode, let rightSoundNode else { fatalError("사운드가 없음") }
        try engine.start()
        leftSoundNode.play()
        rightSoundNode.play()
        try await Task.sleep(nanoseconds: 100)
        leftSoundNode.volume = 1
        rightSoundNode.volume = 1
    }
    
    @SpatialActor func soundStart(leftPath: String,rightPath:String, format: String = "mp3") async throws{
        if leftSoundNode == nil && rightSoundNode == nil{
            leftSoundNode = self.getNode(file: leftPath,withExtension: format, atPosition: AVAudio3DPoint(x: 0, y: 0, z: 0))
            rightSoundNode = self.getNode(file: rightPath, withExtension: format, atPosition: .init(x: 0, y: 0, z: 0))
            let position = getNodePosition()
            leftSoundNode.set2DPosition(position.left)
            rightSoundNode.set2DPosition(position.right)
        }
        
        try! engine.start()
        leftSoundNode.play()
        rightSoundNode.play()
        try await Task.sleep(nanoseconds: 100)
        leftSoundNode.volume = 1
        rightSoundNode.volume = 1
    }
    
    @SpatialActor func soundStop() async throws{
        guard let leftSoundNode, let rightSoundNode else {return}
        leftSoundNode.volume = 0
        rightSoundNode.volume = 0
        try await Task.sleep(nanoseconds: 100)
        leftSoundNode.stop()
        rightSoundNode.stop()
        engine.stop()
        engine.detach(leftSoundNode);engine.detach(rightSoundNode);
        self.leftSoundNode = nil; self.rightSoundNode = nil
    }
    
}
extension SpatialStateImpl{
    func getNode(file:String, withExtension ext:String = "wav", atPosition position:AVAudio3DPoint) -> AVAudioPlayerNode {
        let node = AVAudioPlayerNode()
        node.position = position
        node.reverbBlend = 0.1
        node.renderingAlgorithm = .HRTFHQ
        let url = Bundle.main.url(forResource: file, withExtension: ext)!
        let file = try! AVAudioFile(forReading: url)
        let buffer = AVAudioPCMBuffer(pcmFormat: file.processingFormat, frameCapacity: AVAudioFrameCount(file.length))
        try! file.read(into: buffer!)
        engine.attach(node)
        engine.connect(node, to: environment, format: buffer?.format)
        node.scheduleBuffer(buffer!, at: nil, options: .loops, completionHandler: nil)
        node.sourceMode = .pointSource
        return node
    }
    
    fileprivate func setupSession(){
        do{
            try session.setCategory(.playback, options: [.mixWithOthers,.allowBluetooth,.allowBluetoothA2DP])
        }catch{
            print("setup session error")
        }
    }
}
