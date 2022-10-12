//
//  KYBarChartData.swift
//  KYChartView
//
//  Created by keyon on 2022/10/11.
//

import UIKit

class KYBarChartDataSet {
    var data = [KYBarChartData]()
}

class KYBarChartData {
    let yVal: Double
    var isHighlightEnable = true

    init(yVal: Double) {
        self.yVal = yVal
    }
}
