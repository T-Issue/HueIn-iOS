//
//  SwiftExtensions.swift
//  HueIn
//
//  Created by Greem on 8/5/24.
//

import Foundation
extension Date{
    /// 날짜를 영문 포맷으로 변환
    func formatDateToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: self)
    }
}
extension Int{
    func convertToHMS()->String{
        if self < 60{
            "\(self)h"
        }else if self < 3600{
            "\(self / 60)m \(self % 60)s"
        }else{
            "\(self / 3600)h \((self / 60) % 60)m \(self % 60)s"
        }
    }
}
