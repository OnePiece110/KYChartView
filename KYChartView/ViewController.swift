//
//  ViewController.swift
//  KYChartView
//
//  Created by keyon on 2022/10/11.
//

import UIKit

struct KXLineChartData: KYChartQuote {
    var value: CGFloat
}

struct KXBubbleChartData: KYChartQuote {
    var value: CGFloat
}

class ViewController: UIViewController {

    var lineConfig = KYChartConfiguration()
    lazy var lineView:KYChartRenderView<KXLineChartData> = {
        let group = KYChartGroup<KXLineChartData>(
            height: 100,
            charts: [
                KYAnyChartRenderer(KYGridChartRender()),
                KYAnyChartRenderer(KYLineChartRender())
            ])
        let view = KYChartRenderView(chartRender: group)
        view.backgroundColor = .gray
        return view
    }()
    
    var bubbleConfig = KYChartConfiguration()
    lazy var bubbleView:KYChartRenderView<KXBubbleChartData> = {
        let group = KYChartGroup<KXBubbleChartData>(
            height: 100,
            charts: [
                KYAnyChartRenderer(KXBubbleChartRender())
            ])
        let view = KYChartRenderView(chartRender: group)
        view.backgroundColor = .white
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(lineView)

        lineView.frame = CGRectMake(10, 200, 210, 100)
        let arr = arrayLineRandom()
        lineView.config.spacing = (lineView.frame.width - lineView.config.width * CGFloat(arr.count)) / CGFloat(arr.count - 1)
        lineView.config.edgeInset = .init(top: 4, left: 0, bottom: 4, right: 0)
        lineView.reloadData(arr)
        
        view.addSubview(bubbleView)
        bubbleView.frame = CGRectMake(10, 320, 210, 100)
        bubbleView.config.width = 16
        let bubbleArr = arrayBubbleRandom()
        bubbleView.config.spacing = (bubbleView.frame.width - bubbleView.config.width * CGFloat(bubbleArr.count)) / CGFloat(bubbleArr.count - 1)
        debugPrint(bubbleView.config.spacing)
        bubbleView.reloadData(bubbleArr)
    }

    private func arrayLineRandom() -> [KXLineChartData] {
        var set = [KXLineChartData]()
        let times = 7
        for _ in 0..<times {
            let number = Double.random(in: 1..<100)
            set.append(KXLineChartData(value: number))
//            set.data.append(KYLineChartData(yVal: number - 30))
        }
        return set
    }

    private func arrayBubbleRandom() -> [KXBubbleChartData] {
        var set = [KXBubbleChartData]()
        let times = 7
        for _ in 0..<times {
            let number = Double.random(in: 1..<100)
            set.append(KXBubbleChartData(value: number))
//            set.data.append(KYLineChartData(yVal: number - 30))
        }
        return set
    }
}

