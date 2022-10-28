//
//  KYKChartView.swift
//  KYChartView
//
//  Created by keyon on 2022/10/28.
//

import UIKit
import Combine

class KYKChartView: KYChartBaseView {

    var chartData: KYKLineChartDataSet? {
        didSet {
            calculateMinMaxX()
            calculateMinMaxY()
            setNeedsDisplay()
        }
    }

    private(set) var visibleRange: Range<Int> = .none {
        didSet {
            setNeedsDisplay()
        }
    }

    private(set) var contentOffset: CGPoint = .zero {
        didSet {
            calculateVisibleRange()
        }
    }

    private var render: KYKChartViewRender?
    let config: KYKLineChartConfig
    private var cancelAbles = Set<AnyCancellable>()
    private(set) var minX: Double = 0
    private(set) var maxX: Double = 0
    private(set) var minY: Double = 0
    private(set) var maxY: Double = 0
    
    init(config: KYKLineChartConfig) {
        self.config = config
        super.init()
        self.render = KYKChartViewRender(dataProvider: self)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        publisher(for: \.bounds, options: .new).sink { [weak self] bounds in
            self?.notifyFrameChanged()
        }.store(in: &cancelAbles)
        publisher(for: \.frame, options: .new).sink { [weak self] frame in
            self?.notifyFrameChanged()
        }.store(in: &cancelAbles)

        Publishers.Merge3(config.$spacing, config.$barWidth, config.$shadowLineWidth).sink { [weak self] _ in
            self?.setNeedsDisplay()
        }.store(in: &cancelAbles)
    }

    override func notifyFrameChanged() {
        calculateMinMaxX()
        calculateVisibleRange()
    }

    private func calculateMinMaxX() {
        minX = 0
        // 到了最后不需要有间距,所以需要减去
        maxX = config.thunkWidth * Double(chartData?.data.count ?? 0) - bounds.width - config.spacing
    }

    private func calculateMinMaxY() {
        let tmpMinY = ceil(chartData?.data.max(by: { $0.low > $1.low })?.low ?? 0)
        minY = tmpMinY < 0 ? tmpMinY : 0
        maxY = ceil(chartData?.data.max(by: { $0.high < $1.high })?.high ?? 0)
    }

    private func calculateVisibleRange() {
        guard let chartData = chartData else {
            visibleRange = .none
            return
        }
        let minX = contentOffset.x
        let maxX = minX + bounds.width
        let minIndex = min(chartData.data.count, max(0, Int(minX / config.thunkWidth)))
        let maxIndex = max(0, min(chartData.data.count, Int(floor(maxX / config.thunkWidth))))
        self.visibleRange = minIndex ..< maxIndex
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()
        guard let context = context else { return }

        context.setFillColor(UIColor.lightGray.cgColor)
        context.fill(rect)

        render?.drawKLine(context: context)
    }
}
