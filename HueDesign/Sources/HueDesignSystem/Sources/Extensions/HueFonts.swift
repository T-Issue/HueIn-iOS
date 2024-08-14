//
//  File.swift
//  
//
//  Created by Greem on 7/27/24.
//
import SwiftUI
import WidgetKit
extension Font{
    public enum hue{
        public static let display1 = Font.montserrat(size: 32)
        public static let display2 = Font.montserrat(size: 28)
        public static let title = Font.pretendard(weight: .semibold, size: 32)
        public static let title2 = Font.pretendard(weight: .light, size: 36)
        public static let h1 = Font.pretendard(weight: .semibold, size: 24)
        public static let h2 = Font.pretendard(weight: .semibold, size: 20)
        public static let body = Font.pretendard(weight: .regular, size: 16)
        public static let caption = Font.pretendard(weight: .regular, size: 14)
    }
    public static func pretendard(weight:PretendardWeight,size:CGFloat) -> Font{
        Font.custom("Pretendard-\(weight.name)", size: size)
    }
    public static func montserrat(size:CGFloat) -> Font{
        Font.custom("Montserrat-SemiBold", size: size)
    }
}
public enum CustomFonts {
    public static func registerCustomFonts() {
        guard let montURL = Bundle.designSystem.url(forResource: "Montserrat-SemiBold.ttf", withExtension: nil) else {
            fatalError("Can't load, Montserrat")
        }
        CTFontManagerRegisterFontsForURL(montURL as CFURL, .process, nil)
        for f in PretendardWeight.allCases{
            let font = "Pretendard-\(f.name).otf"
            guard let url = Bundle.designSystem.url(forResource: font, withExtension: nil) else {
                fatalError("Can't load it \(font)")
                return
            }
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        }
    }
}

extension View {
    /// Attach this to any Xcode Preview's view to have custom fonts displayed
    /// Note: Not needed for the actual app
    public func loadHueFontSystem() -> some View {
        CustomFonts.registerCustomFonts()
        return self
    }
}
public enum PretendardWeight:CaseIterable{
    case regular
    case black
    case bold
    case extraBold
    case extraLight
    case light
    case medium
    case semibold
    case thin
    var name:String{
        switch self{
        case .regular:"Regular"
        case .black: "Black"
        case .bold: "Bold"
        case .extraBold: "ExtraBold"
        case .extraLight: "ExtraLight"
        case .light: "Light"
        case .medium: "Medium"
        case .semibold: "SemiBold"
        case .thin: "Thin"
        }
    }
    var textStyle:Font.Weight{
        switch self{
        case .regular: .regular
        case .black: .black
        case .bold: .bold
        case .extraBold: .heavy
        case .extraLight: .thin
        case .light:.ultraLight
        case .medium:.medium
        case .semibold:.semibold
        case .thin:.thin
        }
    }
}
extension Widget{
    public func loadHueFontSystem() -> some Widget {
        CustomFonts.registerCustomFonts()
        return self
    }
}

