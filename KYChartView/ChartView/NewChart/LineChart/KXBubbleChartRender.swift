//
//  KXBubbleChartRender.swift
//  KYChartView
//
//  Created by mac on 2023/10/25.
//

import UIKit

class KXBubbleChartRender<Input: KYChartQuote>: KYChartRenderProtcol {
    
    let bubbleFillLayer = CAShapeLayer()
    let bubbleProgressLayer = CAShapeLayer()
    
    func setup(in view: KYChartRenderView<Input>) {
        view.layer.addSublayer(bubbleFillLayer)
        view.layer.addSublayer(bubbleProgressLayer)
        
        bubbleFillLayer.fillColor = UIColor.gray.cgColor
        bubbleProgressLayer.fillColor = UIColor.green.cgColor
    }
    
    func render(in view: KYChartRenderView<Input>, context: KYChartContext<Input>) {
        
        let path = CGMutablePath()
        let progressPath = CGMutablePath()
        
        for idx in context.visibleRange {
            let data = context.data[idx]
            let point = CGPoint(x: context.layout.quoteMinX(at: idx), y: 0)
             
            path.addRoundedRect(in: CGRect(origin: point, size: CGSize(width: context.configuration.width, height: context.contentRect.height)), cornerWidth: context.configuration.width/2, cornerHeight: context.configuration.width/2)
            
            let height = max(context.yOffset(for: data.value), context.configuration.width)
            let yOffset = context.contentRect.height - height
            let tmpRect = CGRect(
                origin: CGPoint(x: context.layout.quoteMinX(at: idx), y: yOffset),
                size: CGSize(width: context.configuration.width, height: height))
            progressPath.addRoundedRect(in: tmpRect,
                cornerWidth: context.configuration.width/2,
                cornerHeight: context.configuration.width/2)
            
        }
        
        bubbleFillLayer.path = path
        bubbleProgressLayer.path = progressPath
    }
    
    func tearDown(in view: KYChartRenderView<Input>) {
        bubbleFillLayer.removeFromSuperlayer()
        bubbleProgressLayer.removeFromSuperlayer()
    }
    
}
