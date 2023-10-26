//
//  KYPatch.swift
//  KYChartView
//
//  Created by mac on 2023/10/26.
//

import Foundation

public struct KYPatch<V: Hashable> {
    public var deletions: Set<V> = []
    public var insertions: Set<V> = []
}

public extension Set {
    func patches(to another: Set<Element>) -> KYPatch<Element> {
        var path = KYPatch<Element>()
        union(another)
            .forEach { x in
                switch (self.contains(x), another.contains(x)) {
                case (false, true):
                    path.insertions.insert(x)
                case (true, false):
                    path.deletions.insert(x)
                default:
                    break
                }
            }
        return path
    }

    func patches(from another: Set<Element>) -> KYPatch<Element> {
        another.patches(to: self)
    }
}
