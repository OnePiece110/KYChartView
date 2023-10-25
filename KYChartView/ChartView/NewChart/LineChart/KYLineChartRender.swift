//
//  KYLineChartRender.swift
//  KYChartView
//
//  Created by mac on 2023/10/24.
//

import UIKit

class KYLineChartRender<Input: KYChartQuote>: KYChartRenderProtcol {
    
    typealias Input = Input
    
    let lineLayer = CAShapeLayer()
    let circleLayer = CAShapeLayer()
    let ringLayer = CAShapeLayer()
    let selectLineLayer = CAShapeLayer()
    
    func setup(in view: KYChartRenderView<Input>) {
        view.layer.addSublayer(lineLayer)
        view.layer.addSublayer(circleLayer)
        view.layer.addSublayer(selectLineLayer)
        view.layer.addSublayer(ringLayer)
        
        lineLayer.fillColor = UIColor.clear.cgColor
        lineLayer.strokeColor = UIColor.gray.cgColor
        lineLayer.lineWidth = 1
        
        circleLayer.fillColor = UIColor.green.cgColor
        
        ringLayer.fillColor = UIColor.clear.cgColor
        ringLayer.strokeColor = UIColor.red.cgColor
        ringLayer.lineWidth = 1
        
        selectLineLayer.fillColor = UIColor.clear.cgColor
        selectLineLayer.strokeColor = UIColor.orange.cgColor
        selectLineLayer.lineWidth = 1
        
    }
    
    func render(in view: KYChartRenderView<Input>, context: KYChartContext<Input>) {
        
        if context.longGestureIsEnd {
            ringLayer.isHidden = false
            selectLineLayer.isHidden = true
        } else {
            ringLayer.isHidden = true
            selectLineLayer.isHidden = false
        }
        
        let max = view.data.max(by: { $0.value > $1.value })?.value ?? 0
        let min = view.data.max(by: { $0.value < $1.value })?.value ?? 0
        let ep = max - min
        let space = context.configuration.spacing
        
        var points = [CGPoint]()
        var selectPoint: CGPoint?
        for idx in context.visibleRange {
            let data = context.data[idx]
            let point = CGPoint(x: CGFloat(idx) * (space + context.configuration.width) + context.configuration.width / 2 , y: context.configuration.width/2 + ((data.value - min) / ep) * (context.contentRect.height - context.configuration.width))
            if idx == context.selectedIndex {
                selectPoint = point
            }
            points.append(point)
        }
        
        lineLayer.path = .smoothCurve(with: points, granularity: 0.05)
        
        if let point = selectPoint {
            
            let ringPath = UIBezierPath(arcCenter: point, radius: context.configuration.width, startAngle: -CGFloat.pi / 2, endAngle: CGFloat.pi * 1.5, clockwise: true)
            ringLayer.path = ringPath.cgPath
            
            let selectLinePath = CGMutablePath()
            selectLinePath.addVLine(minY: 0, maxY: context.contentRect.height, x: point.x)
            selectLineLayer.path = selectLinePath
            
        }
        
        let circlePath = CGMutablePath()
        for point in points {
            let path = UIBezierPath(arcCenter: point, radius: context.configuration.width / 2, startAngle: -CGFloat.pi / 2, endAngle: CGFloat.pi * 1.5, clockwise: true)
            circlePath.addPath(path.cgPath)
        }
        circleLayer.path = circlePath
    }
    
    func tearDown(in view: KYChartRenderView<Input>) {
        lineLayer.removeFromSuperlayer()
        circleLayer.removeFromSuperlayer()
        ringLayer.removeFromSuperlayer()
    }
    
}
