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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(lineView)

        lineView.frame = CGRectMake(10, 200, 210, 116)
        lineView.contentInset = .init(top: 8, left: 0, bottom: 8, right: 0)
        let arr = arrayLineRandom()
        lineView.config.spacing = (lineView.frame.width - lineConfig.width * CGFloat(arr.count)) / CGFloat(arr.count - 1)
        lineView.reloadData(arr)
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

}

