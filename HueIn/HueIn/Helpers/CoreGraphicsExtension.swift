//
//  CoreGraphicExtension.swift
//  HueIn
//
//  Created by Greem on 8/2/24.
//

import Foundation
import CoreGraphics
import simd
func +(lhs: CGSize, rhs: CGSize) -> CGSize {
    return CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
}
extension CGSize{
    var convertToSIMD:SIMD2<Float>{
        .init(x: Float(self.width), y: Float(self.height))
    }
}

extension Size2D{
    func circularClamp(abs absClamp: Float)-> Self{
        let simdPosition:Size2D = self.clamped(lowerBound: .init(repeating: -absClamp), upperBound: .init(repeating: absClamp))
        let dis:Float = distance(simdPosition, .zero)
        if dis > absClamp{
            let newSimd:SIMD2<Float> = absClamp * simdPosition / dis
            return newSimd
        }else{
            return simdPosition
        }
    }
    var convertToCGSize: CGSize{
        return CGSize(width: CGFloat(self.x), height: CGFloat(self.y))
    }
}
