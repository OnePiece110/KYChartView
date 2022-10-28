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

    let kLineConfig = KYKLineChartConfig()
    lazy var kLineChartView: KYKChartView = {
        return KYKChartView(config: kLineConfig)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(barView)
        view.addSubview(lineView)
        view.addSubview(kLineChartView)
        barView.chartData = arrayRandom()
        barView.frame = CGRectMake(10, 350, 210, 100)

        lineView.chartData = arrayLineRandom()
        lineView.frame = CGRectMake(10, 200, 210, 100)

        kLineChartView.chartData = arrayKLineRandom()
        kLineChartView.frame = CGRect(origin: CGPoint(x: 10, y: 80), size: CGSize(width: 210, height: 100))
    }

    private func arrayRandom() -> KYBarChartDataSet {
        let set = KYBarChartDataSet()
        let times = arc4random_uniform(20) + 100
        for _ in 0...times {
            let number = Double.random(in: 1..<100)
            set.data.append(KYBarChartData(yVal: number - 30))
        }
        return set
    }

    private func arrayLineRandom() -> KYLineChartDataSet {
        let set = KYLineChartDataSet()
        let times = arc4random_uniform(20) + 100
        for _ in 0...times {
            let number = Double.random(in: 1..<100)
            set.data.append(KYLineChartData(yVal: number - 30))
        }
        return set
    }

    private func arrayKLineRandom() -> KYKLineChartDataSet {
        let set = KYKLineChartDataSet()
        let times = arc4random_uniform(20) + 100
        for index in 0...times {
            let number = Double.random(in: 1..<100)

            set.data.append(KYKLineChartData(date: Date(), low: number - 30, high: number + 50, open: number, close: number + (index % 2 == 0 ? 20 : -20), volume: number))
        }
        return set
    }

}

