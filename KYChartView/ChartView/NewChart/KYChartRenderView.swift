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
    
    var chartRender: KYChartDescriptor<Input> {
        didSet {
            updateDescriptor(from: oldValue, to: chartRender)
            invalidateIntrinsicContentSize()
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
    
    init(chartRender: KYChartDescriptor<Input>) {
        self.chartRender = chartRender
        super.init(frame: .zero)
        setup()
        chartRender.groups.forEach { group in
            group.charts.forEach {
                $0.setup(in: self)
            }
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
                             height: chartRender.contentHeight)
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
        
        let maxValue = (data.max(by: { $0.value > $1.value })?.value ?? 0) * 0.5
        let minValue = (data.max(by: { $0.value < $1.value })?.value ?? 0) * 1.5
        var context = KYChartContext(data: data, configuration: config, layout: layout, contentRect: .zero, visibleRange: visibleRange, extremePoint: (minValue, maxValue), longGestureIsEnd: longPressIntercation?.isEnd ?? true)
        
        context.selectedIndex = selectedIndex
        if let selectedIndex = selectedIndex {
            context.indicatorPosition = .init(x: layout.quoteMidX(at: selectedIndex), y: longPressPosition.y)
        }

        var quoteIndex = selectedIndex
        if quoteIndex == nil, !context.visibleRange.isEmpty {
            quoteIndex = context.visibleRange.endIndex - 1
        }

        for (index, group) in chartRender.groups.enumerated() {
            let (y, height) = chartRender.layoutInfoForGroup(at: index)
            context.contentRect = layout.contentRectToDraw(visibleRange: visibleRange, y: y, height: height)
            for item in group.charts {
                item.render(in: self, context: context)
            }
        }
    }
    
    private func updateDescriptor(from lhs: KYChartDescriptor<Input>, to rhs: KYChartDescriptor<Input>) {
        let renderers = rhs.renderers
        let patches = lhs.rendererSet.patches(to: Set(renderers))
        patches.deletions.forEach {
            $0.tearDown(in: self)
        }
        patches.insertions.forEach {
            $0.setup(in: self)
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
        contentInset.top + contentInset.bottom + chartRender.contentHeight
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
