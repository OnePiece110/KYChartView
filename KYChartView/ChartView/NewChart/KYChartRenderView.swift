//
//  KYChartRenderView.swift
//  KYChartView
//
//  Created by mac on 2023/10/24.
//

import UIKit

class KYChartRenderView<Input: KYChartQuote>: UIScrollView {
    
    private(set) var data: [Input] = []
    
    private(set) var selectedIndex: Int? {
        didSet {
            guard oldValue != selectedIndex else { return }
            setNeedRedraw()
            if selectedIndex != nil {
                UIImpactFeedbackGenerator(style: .light).impactOccurred(intensity: 0.75)
            }
            onSelected(selectedIndex)
        }
    }
    
    var onSelected: KYChartDelegate<Int?, Void> = .init()
    
    var config: KYChartConfiguration = .init() {
        didSet {
            setNeedRedraw()
        }
    }
    
    var chartRender: KYChartGroup<Input> {
        didSet {
            oldValue.charts.forEach {
                $0.tearDown(in: self)
            }
            chartRender.charts.forEach {
                $0.setup(in: self)
            }
        }
    }
    
    private var longPressPosition: CGPoint = .zero {
        didSet {
            longPressedPositionChanged(longPressPosition)
            if longPressPosition != oldValue {
                setNeedRedraw()
            }
        }
    }
    
    private var longPressIntercation: KYLongPressIntercation?
    
    public private(set) lazy var layout: KYChartLayout = .init(self)
    
    init(chartRender: KYChartGroup<Input>) {
        self.chartRender = chartRender
        super.init(frame: .zero)
        setup()
        chartRender.charts.forEach {
            $0.setup(in: self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        alwaysBounceHorizontal = true
        setupInteractions()
    }
    
    func reloadData(_ data: [Input]) {
        self.data = data
        _reloadData()
        let offset = CGPoint(x: contentSize.width - bounds.size.width + contentInset.right,
                             y: -contentInset.top)
        setContentOffset(offset, animated: false)
        selectedIndex = nil
        setNeedRedraw()
    }
    
    private func _reloadData() {
        updateContentSize()
    }
    
    private func updateContentSize() {
        contentSize = CGSize(width: layout.contentWidth(for: data),
                             height: chartRender.height)
    }
    
    private func setupInteractions() {
        let position = KYBinding { [unowned self] in
            longPressPosition
        } set: { [unowned self] in
            longPressPosition = $0
        }
        let longPressIntercation = KYLongPressIntercation(binding: position)
        self.longPressIntercation = longPressIntercation
        addInteraction(longPressIntercation)
        let tapInteraction = KYTapInteraction { [unowned self] in
            if selectedIndex != nil {
                selectedIndex = nil
            } else {
                longPressPosition = $0
            }
        }
        addInteraction(tapInteraction)
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer === panGestureRecognizer {
            panGestureDidBegin()
        }
        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }
    
    private func longPressedPositionChanged(_ position: CGPoint) {
        guard let index = layout.quoteIndex(at: position) else { return }
        selectedIndex = index
    }
    
    private func panGestureDidBegin() {
        
    }
    
    private func redraw() {
        let visibleRange = layout.visibleRange()
        
        var context = KYChartContext(data: data, configuration: config, layout: layout, contentRect: .zero, visibleRange: visibleRange, longGestureIsEnd: longPressIntercation?.isEnd ?? true)
        
        context.selectedIndex = selectedIndex
        if let selectedIndex = selectedIndex {
            context.indicatorPosition = .init(x: layout.quoteMidX(at: selectedIndex), y: longPressPosition.y)
        }

        var quoteIndex = selectedIndex
        if quoteIndex == nil, !context.visibleRange.isEmpty {
            quoteIndex = context.visibleRange.endIndex - 1
        }

        for group in chartRender.charts {
            context.contentRect = layout.contentRectToDraw(visibleRange: visibleRange, y: 0, height: chartRender.height)
            group.render(in: self, context: context)
        }
    }
    
    private func setNeedRedraw() {
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        redraw()
    }
    
    open var expectedHeight: CGFloat {
        contentInset.top + contentInset.bottom + chartRender.height
    }
    
    override open var contentInset: UIEdgeInsets {
        didSet {
            setNeedRedraw()
        }
    }

    override open var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.height = expectedHeight
        return size
    }
    
}
