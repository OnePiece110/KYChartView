//
//  KYChartContext.swift
//  KYChartView
//
//  Created by mac on 2023/10/24.
//

import UIKit

struct KYChartContext<Input: KYChartQuote> {
    /// 行情信息
    public var data: [Input]
    /// 配置信息
    public var configuration: KYChartConfiguration
    /// 布局信息
    public var layout: KYChartLayout<Input>
    /// 需要渲染的图表在 ChartView 中的区域
    public var contentRect: CGRect
    /// 需要渲染数据的区间
    public var visibleRange: Range<Int>
    /// 当前选择的 Quote 的下标
    public var selectedIndex: Int?
    /// 当前触摸显示的点
    public var indicatorPosition: CGPoint?
    
    public var extremePoint: (min: CGFloat, max: CGFloat)
    
    var longGestureIsEnd: Bool
}

extension KYChartContext {
    
    func yOffset(for value: CGFloat) -> CGFloat {
        let height = contentRect.height
        let minY = contentRect.minY
        let peak = extremePoint.max - extremePoint.min
        return height - height * (value - extremePoint.min) / peak + minY
    }

    func value(forY y: CGFloat) -> CGFloat {
        let peak = extremePoint.max - extremePoint.min
        let height = contentRect.height
        let maxY = contentRect.maxY
        return (maxY - y) * peak / height + extremePoint.min
    }
}
