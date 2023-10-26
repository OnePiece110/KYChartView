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
        var points = [CGPoint]()
        for idx in context.visibleRange {
            let data = context.data[idx]
            let point = CGPoint(x: context.layout.quoteMidX(at: idx), y: context.yOffset(for: data.value))
            points.append(point)
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


