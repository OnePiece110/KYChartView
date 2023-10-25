//
//  KYLongPressIntercation.swift
//  KYChartView
//
//  Created by mac on 2023/10/24.
//

import UIKit

class KYLongPressIntercation: NSObject, UIInteraction {
    weak var view: UIView?
    private lazy var gesture: UILongPressGestureRecognizer = .init(target: self, action: #selector(handleLongPress(gesture:)))
    private(set) var isEnd = false
    
    private var binding: KYBinding<CGPoint>

    init(binding: KYBinding<CGPoint>) {
        self.binding = binding
        super.init()
        gesture.delegate = self
    }

    func willMove(to view: UIView?) {
        self.view?.removeGestureRecognizer(gesture)
        self.view = nil
    }

    func didMove(to view: UIView?) {
        self.view = view
        view?.addGestureRecognizer(gesture)
    }

    @objc private func handleLongPress(gesture: UILongPressGestureRecognizer) {
        guard let view = view else { return }
        switch gesture.state {
        case .began, .changed:
            self.isEnd = false
            binding.wrappedValue = gesture.location(in: view)
        default:
            binding.wrappedValue = .init(x: -1, y: -1)
            self.isEnd = true
            binding.wrappedValue = gesture.location(in: view)
            break
        }
    }
}

extension KYLongPressIntercation: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer is UIPanGestureRecognizer {
            return false
        }
        return otherGestureRecognizer.view !== view
    }
}
