//
//  KYGridChartRender.swift
//  KYChartView
//
//  Created by mac on 2023/10/25.
//

import UIKit

class KYGridChartRender<Input: KYChartQuote>: KYChartRenderProtcol {
    
    let gridLayer = CAShapeLayer()
    
    func setup(in view: KYChartRenderView<Input>) {
        view.layer.addSublayer(gridLayer)
        
        gridLayer.fillColor = UIColor.clear.cgColor
        gridLayer.strokeColor = UIColor.lightGray.cgColor
        gridLayer.lineWidth = 1
    }
    
    func render(in view: KYChartRenderView<Input>, context: KYChartContext<Input>) {
        let max = view.data.max(by: { $0.value > $1.value })?.value ?? 0
        let min = view.data.max(by: { $0.value < $1.value })?.value ?? 0
        let ep = max - min
        let space = context.configuration.spacing
        
        var points = [CGPoint]()
        for idx in context.visibleRange {
            let data = context.data[idx]
            points.append(.init(x: CGFloat(idx) * (space + context.configuration.width) + context.configuration.width / 2 , y: context.configuration.width/2 + ((data.value - min) / ep) * (context.contentRect.height - context.configuration.width)))
        }
        
        let gridPath = CGMutablePath()
        
        for point in points {
            gridPath.addVLine(minY: 0, maxY: context.contentRect.height, x: point.x)
        }
        gridLayer.path = gridPath
    }
    
    func tearDown(in view: KYChartRenderView<Input>) {
        gridLayer.removeFromSuperlayer()
    }
    
}


