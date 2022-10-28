//
//  KYBarChartRender.swift
//  KYChartView
//
//  Created by keyon on 2022/10/11.
//

import UIKit

class KYBarChartRender {

    private weak var dataProvider: KYBarChartView?

    init(dataProvider: KYBarChartView) {
        self.dataProvider = dataProvider
    }

    func drawData(context: CGContext) {
        guard let dataProvider = dataProvider, let chartData = dataProvider.chartData else { return }

        context.saveGState()
        defer { context.restoreGState() }

        var x:Double = 0
        var y:Double = 0
        for index in dataProvider.visibleRange {
            let data = chartData.data[index]
            if !data.isHighlightEnable { continue }

            let height = (data.yVal - dataProvider.minY) / (dataProvider.maxY - dataProvider.minY) * Double(dataProvider.bounds.height)
            y = dataProvider.bounds.height - height
            x = dataProvider.config.thunkWidth * Double(index) - dataProvider.contentOffset.x

            context.setFillColor(UIColor.yellow.cgColor)
            context.fill(CGRect(x: x, y: y, width: dataProvider.config.barWidth, height: height))
        }
    }

    func drawHighlighted(context: CGContext, indices: [KYBarChartHighLight]) {
        guard let dataProvider = dataProvider, let chartData = dataProvider.chartData else { return }

        context.saveGState()
        defer { context.restoreGState() }
        
        var x:Double = 0
        var y:Double = 0
        for high in indices {
            let data = chartData.data[high.dataIndex]
            if !data.isHighlightEnable { continue }

            let height = data.yVal / dataProvider.maxY * Double(dataProvider.bounds.height)
            y = dataProvider.bounds.height - height
            x = dataProvider.config.thunkWidth * CGFloat(high.dataIndex) - dataProvider.contentOffset.x
            let rect = CGRect(x: x, y: y, width: dataProvider.config.barWidth, height: height)

            context.setFillColor(UIColor.red.cgColor)
            context.fill(rect)

            drawVerticalHighlightLines(context: context, rect: rect)
            drawHorizontalHighlightLines(context: context, rect: rect)
        }
    }

    func drawVerticalHighlightLines(context: CGContext, rect: CGRect) {
        guard let dataProvider = dataProvider else { return }

        context.saveGState()
        defer { context.restoreGState() }

        context.setStrokeColor(UIColor.blue.cgColor)
        context.setLineWidth(1)
        context.setLineDash(phase: 0.6, lengths: [5, 2.5])

        context.beginPath()
        context.move(to: CGPoint(x: rect.origin.x + dataProvider.config.barWidth / 2, y: 0))
        context.addLine(to: CGPoint(x: rect.origin.x + dataProvider.config.barWidth / 2, y: rect.origin.y + rect.size.height))
        context.strokePath()
    }

    func drawHorizontalHighlightLines(context: CGContext, rect: CGRect) {
        guard let dataProvider = dataProvider else { return }

        context.saveGState()
        defer { context.restoreGState() }

        context.setStrokeColor(UIColor.blue.cgColor)
        context.setLineWidth(1)
        context.setLineDash(phase: 0.6, lengths: [5, 2.5])

        context.beginPath()
        context.move(to: CGPoint(x: 0, y: rect.origin.y))
        context.addLine(to: CGPoint(x: dataProvider.bounds.width, y: rect.origin.y))
        context.strokePath()
    }
    
}
