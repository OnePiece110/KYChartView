//
//  KYChartGroup.swift
//  KYChartView
//
//  Created by mac on 2023/10/24.
//

import UIKit

struct KYChartDescriptor<Input: KYChartQuote> {
    let spacing: CGFloat
    let groups: [KYChartGroup<Input>]
    private var cache: [(y: CGFloat, height: CGFloat)] = []
    
    init(spacing: CGFloat = 0, groups: [KYChartGroup<Input>]) {
        self.spacing = spacing
        self.groups = groups
        cacheLayoutInfo()
    }
    
    private mutating func cacheLayoutInfo() {
        guard groups.count > 0 else { return }
        var y: CGFloat = 0
        for group in groups {
            cache.append((y, group.height))
            y += spacing + group.height
        }
    }
    
    func groupIndex(contains point: CGPoint) -> Int? {
        for (index, (y, height)) in cache.enumerated() where point.y >= y && point.y <= y + height {
            return index
        }
        return nil
    }
}

extension KYChartDescriptor {
    var contentHeight: CGFloat {
        guard groups.count > 0 else { return 0 }
        return cache.last!.y + cache.last!.height
    }
    
    func layoutInfoForGroup(at index: Int) -> (y: CGFloat, height: CGFloat) {
        cache[index]
    }
    
    var renderers: [KYAnyChartRenderer<Input>] {
        groups.flatMap { $0.charts }
    }
    
    var rendererSet: Set<KYAnyChartRenderer<Input>> {
        Set(renderers)
    }
}

struct KYChartGroup<Input: KYChartQuote> {
    var height: CGFloat
    var charts: [KYAnyChartRenderer<Input>]
    
    init(height: CGFloat,
         charts: [KYAnyChartRenderer<Input>]) {
        self.height = height
        self.charts = charts
    }
}
