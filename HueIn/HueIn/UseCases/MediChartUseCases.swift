//
//  MediChartUseCases.swift
//  HueIn
//
//  Created by Greem on 8/2/24.
//

import Foundation
import Health_Remind

extension MediChartItem{
    static func getLast7DaysItems(health: any HealthKitService) async throws ->[MediChartItem]{
        let dicts = try await health.lastWeekSecondsList()
        let calenedar = Calendar.current
        var arr:[MediChartItem] = (-6...0).map{
            let date = Date().getDateByAddingDay($0,startDate: true)
            return MediChartItem(date: date, seconds: 0)
        }
        for (idx, val) in arr.enumerated(){
            arr[idx].seconds += dicts[val.date] ?? 0
        }
        return arr
    }
}
