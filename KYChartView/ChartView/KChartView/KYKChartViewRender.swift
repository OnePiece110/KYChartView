//
//  KYKChartViewRender.swift
//  KYChartView
//
//  Created by keyon on 2022/10/28.
//

import UIKit

class KYKChartViewRender {

    private weak var dataProvider: KYKChartView?
    let minHeight: Double = 1

    init(dataProvider: KYKChartView) {
        self.dataProvider = dataProvider
        dataProvider.layer.addSublayer(upLayer)
        dataProvider.layer.addSublayer(downLayer)
    }

    func drawKLine(context: CGContext) {
        guard let dataProvider = dataProvider, let chartData = dataProvider.chartData else { return }

        context.saveGState()
        defer { context.restoreGState() }

        upLayer.fillColor = dataProvider.config.upColor.cgColor
        downLayer.fillColor = dataProvider.config.downColor.cgColor

        let upPath = CGMutablePath()
        let downPath = CGMutablePath()
        for index in dataProvider.visibleRange {
            let data = chartData.data[index]
            if data.open > data.close {
                writePath(into: downPath, data: data, index: index)
            } else {
                writePath(into: upPath, data: data, index: index)
            }
        }

        upLayer.path = upPath
        downLayer.path = downPath
        
    }

    private func writePath(into path: CGMutablePath,
                           data: KYKLineChartData,
                           index: Int) {
        guard let dataProvider = dataProvider else { return }

        let barWidth = dataProvider.config.barWidth
        let shadowWidth = dataProvider.config.shadowLineWidth
        let barX = dataProvider.config.thunkWidth * Double(index) - dataProvider.contentOffset.x
        let lineX = barX + (barWidth - shadowWidth) / 2

        let barRect = rect(for: (data.open, data.close),
                           x: _pixelCeil(barX),
                           width: barWidth,
                           minHeight: minHeight)
        path.addRect(barRect)

        let lineRect = rect(for: (data.low, data.high),
                            x: _pixelCeil(lineX),
                            width: shadowWidth,
                            minHeight: minHeight)
        path.addRect(lineRect)
    }

    private func rect(for pricePair: (CGFloat, CGFloat), x: CGFloat, width: CGFloat, minHeight: CGFloat) -> CGRect {
        let y1 = yOffset(for: pricePair.0)
        let y2 = yOffset(for: pricePair.1)
        let y = _pixelCeil(min(y1, y2))
        let height = max(_pixelCeil(abs(y1 - y2)), minHeight)
        return CGRect(x: x, y: y, width: width, height: height)
    }

    private func yOffset(for price: CGFloat) -> Double {
        guard let dataProvider = dataProvider else { return 0 }
        let height = dataProvider.bounds.height
        let peak = dataProvider.maxY - dataProvider.minY
        return height * (price + abs(dataProvider.minY)) / abs(peak)
    }

    private var upLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        return layer
    }()

    private var downLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        return layer
    }()
}
