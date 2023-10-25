//
//  KYChartRenderProtcol.swift
//  KYChartView
//
//  Created by mac on 2023/10/24.
//

import UIKit

protocol KYChartRenderProtcol: AnyObject {
    associatedtype Input: KYChartQuote
    /// 加载到 ChartView 的时候，会渲染一次
    func setup(in view: KYChartRenderView<Input>)
    /// 当时图滚动或者数据发生变化时，会调用该方法进行绘制
    func render(in view: KYChartRenderView<Input>, context: KYChartContext<Input>)
    /// 从 ChartView 卸载的时候，会调用一次
    func tearDown(in view: KYChartRenderView<Input>)
}

struct KYAnyChartRenderer<Input: KYChartQuote> {
    var _setup: (KYChartRenderView<Input>) -> Void
    var _render: (KYChartRenderView<Input>, KYChartContext<Input>) -> Void
    var _tearDown: (KYChartRenderView<Input>) -> Void
    var base: AnyObject

    public init<R: KYChartRenderProtcol>(_ renderer: R) where R.Input == Input {
        _setup = { renderer.setup(in: $0) }
        _render = { renderer.render(in: $0, context: $1) }
        _tearDown = { renderer.tearDown(in: $0) }
        base = renderer
    }

    func setup(in view: KYChartRenderView<Input>) {
        _setup(view)
    }

    func render(in view: KYChartRenderView<Input>, context: KYChartContext<Input>) {
        _render(view, context)
    }

    func tearDown(in view: KYChartRenderView<Input>) {
        _tearDown(view)
    }
}
