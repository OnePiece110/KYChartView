//
//  KYLineChartViewRender.swift
//  KYChartView
//
//  Created by keyon on 2022/10/12.
//

import UIKit

class KYLineChartViewRender {

    private weak var dataProvider: KYLineChartView?

    init(dataProvider: KYLineChartView) {
        self.dataProvider = dataProvider
    }

    func drawLinear(context: CGContext) {
        guard let dataProvider = dataProvider, let chartData = dataProvider.chartData else { return }

        var isFirstPoint = true
        let path = CGMutablePath()

        for index in dataProvider.visibleRange {
            let data = chartData.data[index]
            let startPoint = CGPoint(x: Double(index) * dataProvider.config.spacing - dataProvider.contentOffset.x, y: (data.yVal - dataProvider.minY) / (dataProvider.maxY - dataProvider.minY) * dataProvider.bounds.height)

            if isFirstPoint {
                path.move(to: startPoint)
                isFirstPoint = false
            } else {
                path.addLine(to: startPoint)
            }
        }

        if !isFirstPoint {
            context.beginPath()
            context.addPath(path)
            context.setStrokeColor(UIColor.yellow.cgColor)
            context.strokePath()
        }

    }
    
}
