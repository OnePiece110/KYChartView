//
//  CGPathExtension.swift
//  KYChartView
//
//  Created by mac on 2023/10/25.
//

import UIKit

extension CGPath {
    static func lineSegments(with points: [CGPoint]) -> CGMutablePath {
        let path = CGMutablePath()
        guard let first = points.first else { return path }
        path.move(to: first)
        points.dropFirst().forEach { path.addLine(to: $0) }
        return path
    }
    
    private static func directionVector(from: CGPoint, to: CGPoint) -> CGVector {
        .init(dx: to.x - from.x, dy: to.y - from.y)
            .normalized ?? CGVector(dx: 1, dy: 0)
    }
    
    static func smoothCurve(with points: [CGPoint], granularity: CGFloat) -> CGMutablePath {
        let path = CGMutablePath()
        let count = points.count
        guard count > 1 else { return path }
        var preVector = CGVector(dx: 1, dy: 0)
        var currentVector: CGVector = .zero

        func addCurve(from: CGPoint, to: CGPoint) {
            let distance = (to - from).norm
            let controlP1 = from + preVector * distance * granularity
            let controlP2 = to - currentVector * distance * granularity
            path.addCurve(to: to, control1: controlP1, control2: controlP2)
        }
        path.move(to: points[0])
        for index in 1 ..< (count - 1) {
            currentVector = directionVector(from: points[index - 1], to: points[index + 1])
            defer { preVector = currentVector }
            addCurve(from: points[index - 1], to: points[index])
        }
        currentVector = .init(dx: 1, dy: 0)
        addCurve(from: points[count - 2], to: points[count - 1])
        return path
    }
}

extension CGMutablePath {
    func addVLine(minY: CGFloat, maxY: CGFloat, x: CGFloat) {
        move(to: .init(x: x, y: minY))
        addLine(to: .init(x: x, y: maxY))
    }
}
