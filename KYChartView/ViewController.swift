//
//  ViewController.swift
//  KYChartView
//
//  Created by keyon on 2022/10/11.
//

import UIKit

class ViewController: UIViewController {

    let config = KYBarChartConfig()
    lazy var barView:KYBarChartView = {
        return KYBarChartView(config: config)
    }()

    let lineConfig = KYLineChartConfig()
    lazy var lineView:KYLineChartView = {
        return KYLineChartView(config: lineConfig)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(barView)
        view.addSubview(lineView)
        barView.chartData = arrayRandom()
        barView.frame = CGRectMake(10, 350, 210, 100)

        lineView.chartData = arrayLineRandom()
        lineView.frame = CGRectMake(10, 200, 210, 100)
    }

    private func arrayRandom() -> KYBarChartDataSet {
        let set = KYBarChartDataSet()
        let times = arc4random_uniform(20) + 100
        for _ in 0...times {
            let number = Double.random(in: 1..<100)
            set.data.append(KYBarChartData(yVal: number))
        }
        return set
    }

    private func arrayLineRandom() -> KYLineChartDataSet {
        let set = KYLineChartDataSet()
        let times = arc4random_uniform(20) + 100
        for _ in 0...times {
            let number = Double.random(in: 1..<100)
            set.data.append(KYLineChartData(yVal: number))
        }
        return set
    }

}

