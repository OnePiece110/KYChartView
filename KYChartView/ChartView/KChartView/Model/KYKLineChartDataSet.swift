//
//  KYKLineChartDataSet.swift
//  KYChartView
//
//  Created by keyon on 2022/10/27.
//

import Foundation

class KYKLineChartDataSet {
    var data = [KYKLineChartData]()
}

/// 报价
class KYKLineChartData {
    /// 日期
    let date: Date
    /// 最低价
    let low: CGFloat
    /// 最高价
    let high: CGFloat
    /// 开盘价
    let open: CGFloat
    /// 收盘价
    let close: CGFloat
    /// 交易量
    let volume: CGFloat
    
    init(date: Date, low: CGFloat, high: CGFloat, open: CGFloat, close: CGFloat, volume: CGFloat) {
        self.date = date
        self.low = low
        self.high = high
        self.open = open
        self.close = close
        self.volume = volume
    }
}
