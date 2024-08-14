import XCTest
@testable import HueViews
@testable import HueDesignSystem
import SwiftUI
final class HueViewsTests: XCTestCase {
    @State private var wow:[Int] = [1,2,3]
    func testExample() throws {
        // XCTest Documentation
        // https://developer.apple.com/documentation/xctest

        // Defining Test Cases and Test Methods
        // https://developer.apple.com/documentation/xctest/defining_test_cases_and_test_methods
//        let designBundle = Bundle.designSystem
        CustomFonts.registerCustomFonts()
    }
}
