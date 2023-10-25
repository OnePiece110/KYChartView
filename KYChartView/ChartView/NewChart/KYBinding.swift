//
//  KYBinding.swift
//  KYChartView
//
//  Created by mac on 2023/10/24.
//

import Foundation

public struct KYBinding<V> {
    private var getter: () -> V
    private var setter: (V) -> Void

    public var wrappedValue: V {
        get {
            getter()
        }
        set {
            setter(newValue)
        }
    }

    public init(get: @escaping () -> V, set: @escaping (V) -> Void) {
        self.getter = get
        self.setter = set
    }
}
