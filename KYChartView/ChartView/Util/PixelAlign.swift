//
//  PixelAlign.swift
//  KYChartView
//
//  Created by keyon on 2022/10/28.
//

import Foundation
import UIKit

/*
 * 用于像素对齐，防止发生复杂的颜色混合
 */
@inlinable func _pixelCeil(_ value: CGFloat) -> CGFloat {
    ceil(value * max(1, UIScreen.main.scale)) / max(1, UIScreen.main.scale)
}
