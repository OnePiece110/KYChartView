//
//  KYTapInteraction.swift
//  KYChartView
//
//  Created by mac on 2023/10/24.
//

import UIKit

class KYTapInteraction: NSObject, UIInteraction {
    weak var view: UIView?
    private lazy var gesture: UITapGestureRecognizer = .init(target: self, action: #selector(handleTap(gesture:)))

    private var handler: (CGPoint) -> Void

    init(handler: @escaping (CGPoint) -> Void) {
        self.handler = handler
        super.init()
    }

    func willMove(to view: UIView?) {
        self.view?.removeGestureRecognizer(gesture)
        self.view = nil
    }

    func didMove(to view: UIView?) {
        self.view = view
        view?.addGestureRecognizer(gesture)
    }

    @objc private func handleTap(gesture: UILongPressGestureRecognizer) {
        guard let view = view else { return }
        handler(gesture.location(in: view))
    }
}
