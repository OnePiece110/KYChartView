//
//  KYLineChartView.swift
//  KYChartView
//
//  Created by keyon on 2022/10/12.
//

import UIKit
import Combine

class KYLineChartView: KYChartBaseView {

    var chartData: KYLineChartDataSet? {
        didSet {
            calculateMinMaxX()
            calculateMinMaxY()
            setNeedsDisplay()
        }
    }

    var visibleRange: Range<Int> = .none {
        didSet {
            setNeedsDisplay()
        }
    }

    var maxY: Double {
        return _maxY
    }

    let config: KYLineChartConfig

    private(set) var contentOffset: CGPoint = .zero {
        didSet {
            calculateVisibleRange()
        }
    }

    private var render: KYLineChartViewRender?
    private var lastContentOffset: CGPoint = .zero
    private var _minX: Double = 0
    private var _maxX: Double = 0
    private var _minY: Double = 0
    private var _maxY: Double = 0
    private var cancelAbles = Set<AnyCancellable>()

    init(config: KYLineChartConfig) {
        self.config = config
        super.init()
        self.render = KYLineChartViewRender(dataProvider: self)
        setup()
    }

    private func setup() {
        publisher(for: \.bounds, options: .new).sink { [weak self] bounds in
            self?.notifyFrameChanged()
        }.store(in: &cancelAbles)
        publisher(for: \.frame, options: .new).sink { [weak self] frame in
            self?.notifyFrameChanged()
        }.store(in: &cancelAbles)

        config.$spacing.sink { [weak self] _ in
            self?.setNeedsDisplay()
        }.store(in: &cancelAbles)
    }

    private func calculateMinMaxX() {
        _minX = 0
        _maxX = config.spacing * Double(chartData?.data.count ?? 0) - bounds.width
    }
    
    private func calculateMinMaxY() {
        _minY = 0
        _maxY = ceil(chartData?.data.max(by: { $0.yVal < $1.yVal })?.yVal ?? 0)
    }

    override func notifyFrameChanged() {
//        calculateMinMaxX()
        calculateVisibleRange()
    }

    override func panGestureRecognized(_ recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .changed {
            let originalTranslation = recognizer.translation(in: self)
            contentOffset.x = -originalTranslation.x + lastContentOffset.x
            if contentOffset.x <= _minX {
                contentOffset.x = _minX
            } else if contentOffset.x >= _maxX {
                contentOffset.x = _maxX
            }
        } else if recognizer.state == .ended {
            lastContentOffset = contentOffset
        }
    }

    private func calculateVisibleRange() {
        guard let chartData = chartData else {
            visibleRange = .none
            return
        }
        let minX = contentOffset.x
        let maxX = minX + bounds.width
        let minIndex = min(chartData.data.count, max(0, Int(minX / config.spacing)))
        let maxIndex = max(0, min(chartData.data.count, Int(ceil(maxX / config.spacing)) + 1))
        self.visibleRange = minIndex ..< maxIndex
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()
        guard let context = context else { return }

        context.setFillColor(UIColor.lightGray.cgColor)
        context.fill(rect)

        render?.drawLinear(context: context)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
