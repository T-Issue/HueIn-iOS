//
//  LiveActivityClient.swift
//  HueIn
//
//  Created by Greem on 8/5/24.
//

import Foundation
import ActivityKit

final class MediLiveActivityImpl: NSObject, MediLiveActivity{
    private var currentID:String = ""
    static let shared = MediLiveActivityImpl()
    private override init(){ super.init() }
    func updateActivity(mediType:Medi) async {
        if let activity = Activity.activities.first(where: { (activity:Activity<MediAttributes>) in
            activity.id == currentID
        }){
            print("업데이트가 진행된다.")
            let difference = Int(Date().timeIntervalSince(activity.content.state.startDate))
            let restCount = max(0,activity.content.state.count - difference)
            print(restCount)
            let updateState = MediAttributes.ContentState(mediType: mediType,restCount: restCount, count: activity.content.state.count, startDate: activity.content.state.startDate)
            let content = ActivityContent(state: updateState, staleDate: nil)
            await activity.update(content)
        }else{
            print("아무런 정보가 없다")
        }
    }
    func addActivity(mediType:Medi,count:Int)  async {
        var mediAttributes = MediAttributes()
        let initialState = MediAttributes.ContentState(mediType: mediType,restCount: count,count: count,startDate: Date())
        let content = ActivityContent(state: initialState, staleDate: nil)
        do{
            let activity = try Activity<MediAttributes>.request(attributes: mediAttributes, content: content)
            self.currentID = activity.id
            print("추가 성공 \(activity.content.state.count)")
        }catch{
            print("추가 실패")
            print(error.localizedDescription)
        }
    }
    
    func createActivity(mediType:Medi,count:Int) async{
        if let activity = Activity.activities.first(where: { (activity:Activity<MediAttributes>) in
            activity.id == currentID
        }){
            print("업데이트 실행")
            await updateActivity(mediType: mediType)
        }else{
            await addActivity(mediType: mediType, count: count)
        }
    }
    
    func removeActivity() async {
        await self.removeActivity(dismissPolicy: .immediate)
    }
    func removeActivity(dismissPolicy: ActivityUIDismissalPolicy = .default) async {
        for activity in Activity<MediAttributes>.activities{
            await activity.end(activity.content,dismissalPolicy: dismissPolicy)
        }
    }
}
