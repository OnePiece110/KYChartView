//
//  KYKLineChartConfig.swift
//  KYChartView
//
//  Created by keyon on 2022/10/28.
//

import UIKit
import Combine

class KYKLineChartConfig {

    /// 每个报价在图表中的宽度，默认 6
    @Published var barWidth: CGFloat = 6
    /// 报价之间的间隔，默认 1
    @Published var spacing: CGFloat = 2
    /// 影线宽度，默认 1
    @Published var shadowLineWidth: CGFloat = 1
    /// 上升趋势的颜色
    public var upColor: UIColor = .red
    /// 下降趋势的颜色
    public var downColor: UIColor = .green

    var thunkWidth: Double {
        return barWidth + spacing
    }
}
