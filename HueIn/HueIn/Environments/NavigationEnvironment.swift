//
//  NavigationEnvironment.swift
//  HueIn
//
//  Created by Greem on 8/1/24.
//

import SwiftUI
import UIKit
struct UINavigationControllerStateKey : EnvironmentKey{
    static var defaultValue: UINavigationControllerState = UINavigationControllerStateImpl.shared
}
extension EnvironmentValues{
    var navigationControllerState: UINavigationControllerState{
        get{ self[UINavigationControllerStateKey.self] }
        set{ self[UINavigationControllerStateKey.self] = newValue }
    }
}

protocol UINavigationControllerState:NSObject{
    var allowsSwipeBack: Bool {get set}
}
final class UINavigationControllerStateImpl:NSObject, UINavigationControllerState {
    fileprivate static var shared = UINavigationControllerStateImpl()
    var allowsSwipeBack: Bool = true
}
extension UINavigationController: ObservableObject, UIGestureRecognizerDelegate {
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard UINavigationControllerStateImpl.shared.allowsSwipeBack else { return false }
        return viewControllers.count > 1
    }
}
