//
//  KYChartLayout.swift
//  KYChartView
//
//  Created by mac on 2023/10/24.
//

import UIKit

struct KYChartLayout<Input: KYChartQuote> {
    unowned var view: KYChartRenderView<Input>
    private var configuration: KYChartConfiguration { view.config }

    
    init(_ view: KYChartRenderView<Input>) {
        self.view = view
    }

    public func contentWidth(for data: [Input]) -> CGFloat {
        let width = view.frame.width - view.contentInset.left - view.contentInset.right
        guard data.count > 0 else { return width }
        let contentWidth = (configuration.width + configuration.spacing) * CGFloat(data.count) - configuration.spacing
        return max(width, contentWidth)
    }

    public func visibleRange() -> Range<Int> {
        guard view.data.count > 0 else { return .none }
        let minX = view.contentOffset.x
        let maxX = minX + view.frame.width
        let thunkWidth = configuration.width + configuration.spacing
        let minIndex = min(view.data.count, max(0, Int(minX / thunkWidth)))
        let maxIndex = max(0, min(view.data.count, Int(ceil(maxX / thunkWidth)) + 1))
        return minIndex ..< maxIndex
    }

    public func contentRectToDraw(visibleRange: Range<Int>, y: CGFloat, height: CGFloat) -> CGRect {
        guard !visibleRange.isEmpty else { return CGRect(x: 0, y: y, width: 0, height: height) }
        let thunkWidth = configuration.width + configuration.spacing
        let minX = CGFloat(visibleRange.startIndex) * thunkWidth
        let maxX = CGFloat(visibleRange.endIndex - 1) * thunkWidth
        return CGRect(x: minX, y: y, width: maxX - minX - configuration.edgeInset.left - configuration.edgeInset.right, height: height)
    }
}

extension KYChartLayout {
    var barWidth: CGFloat {
        configuration.width
    }

    var spacing: CGFloat {
        configuration.spacing
    }

    func quoteMinX(at index: Int) -> CGFloat {
        let thunkWidth = configuration.width + configuration.spacing
        return thunkWidth * CGFloat(index)
    }

    func quoteMidX(at index: Int) -> CGFloat {
        let thunkWidth = configuration.width + configuration.spacing
        return thunkWidth * CGFloat(index) + configuration.width / 2
    }

    func quoteMaxX(at index: Int) -> CGFloat {
        let thunkWidth = configuration.width + configuration.spacing
        return thunkWidth * CGFloat(index) + configuration.width
    }

    func quoteIndex(at point: CGPoint) -> Int? {
        let thunkWidth = configuration.width + configuration.spacing
        let index = Int(point.x / thunkWidth)
        guard index >= 0, index < view.data.count else { return nil }
        return index
    }
}
