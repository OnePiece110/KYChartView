//
//  KYChartDelegate.swift
//  KYChartView
//
//  Created by mac on 2023/10/24.
//

import Foundation

class KYChartDelegate<Input, Output> {
    
    private var block: ((Input) -> Output?)?
    
    func delegate<Target: AnyObject>(on target: Target, action: @escaping (Target, Input) -> Output) {
        block = { [weak target] in
            guard let target = target else { return nil }
            return action(target, $0)
        }
    }
    
    func callAsFunction(_ input: Input) -> Output? {
        block?(input)
    }
}
