//
//  KYBarChartConfig.swift
//  KYChartView
//
//  Created by keyon on 2022/10/11.
//

import UIKit

class KYBarChartConfig {

    @Published var barWidth: Double = 12

    @Published var spacing: Double = 6

    var thunkWidth: Double {
        return barWidth + spacing
    }

}
