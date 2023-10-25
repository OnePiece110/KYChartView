//
//  KYChartGroup.swift
//  KYChartView
//
//  Created by mac on 2023/10/24.
//

import UIKit

struct KYChartGroup<Input: KYChartQuote> {
    var height: CGFloat
    var charts: [KYAnyChartRenderer<Input>]
    
    init(height: CGFloat,
         charts: [KYAnyChartRenderer<Input>]) {
        self.height = height
        self.charts = charts
    }
}
