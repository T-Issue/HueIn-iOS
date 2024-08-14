//
//  StoreEnvironment.swift
//  HueIn
//
//  Created by Greem on 8/5/24.
//

import SwiftUI
import Combine
import StoreKit
import StoreKitTest

struct StoreKey : EnvironmentKey{
    static var defaultValue: StoreState = PurchaseManager.shared
}
extension EnvironmentValues{
    var store: StoreState{
        get{ self[StoreKey.self] }
        set{ self[StoreKey.self] = newValue }
    }
}
protocol StoreState:NSObject{
    var isProUser:Bool{ get }
    var products: [Product] {get} // 상품들이 무엇인지 나타내는 프로토콜
    var purchasedProductIDs:Set<String> { get }
    var refundTransactionID: StoreKit.Transaction.ID {get}
    func loadProducts() async throws
    func purchase() async throws
    func updatePurchasedProducts() async
    func eventAsyncStream() async -> AsyncStream<PurchaseEvent>
    func restore() async -> Bool
}

