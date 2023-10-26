//
//  KYGradientLayer.swift
//  KYChartView
//
//  Created by mac on 2023/10/25.
//

import UIKit

class KYGradientLayer: CALayer {
    
    let gradientLayer = CAGradientLayer()
    let maskLayer = CAShapeLayer()
    
    override public init() {
        super.init()
        addSublayer(gradientLayer)
        gradientLayer.mask = maskLayer
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update<Input: KYChartQuote>(with context: KYChartContext<Input>) {
        guard !context.visibleRange.isEmpty else { return }
        let start = max(0, context.visibleRange.startIndex - 1)
        let end = min(context.data.count, context.visibleRange.endIndex + 1)
        let minX = context.layout.quoteMinX(at: start)
        let maxX = context.layout.quoteMidX(at: end - 1)
        var rect = context.contentRect
        let minY = rect.minY
        rect.origin.x = minX
        rect.size.width = maxX - minX
        self.frame = rect
        gradientLayer.frame = bounds
        
        var points = [CGPoint]()
        for idx in (start ..< end){
            let data = context.data[idx]
            let point = CGPoint(x: context.layout.quoteMidX(at: idx) - minX, y: context.yOffset(for: data.value) - minY)
            points.append(point)
        }
        
        let path = CGMutablePath.smoothCurve(with: points, granularity: 0.3)
        
        path.addLine(to: CGPoint(x: frame.width, y: frame.height))
        path.addLine(to: CGPoint(x: points.first?.x ?? 0, y: frame.height))
        path.addLine(to: CGPoint(x: points.first?.x ?? 0, y: points.first?.y ?? 0))
        maskLayer.path = path
    }
}
