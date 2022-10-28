//
//  KYLineChartModel.swift
//  KYChartView
//
//  Created by keyon on 2022/10/12.
//

import UIKit

class KYLineChartDataSet {
    var data = [KYLineChartData]()
}

class KYLineChartData {
    let yVal: Double

    init(yVal: Double) {
        self.yVal = yVal
    }
}
