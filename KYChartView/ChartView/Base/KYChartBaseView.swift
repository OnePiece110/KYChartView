//
//  KYChartBaseView.swift
//  KYChartView
//
//  Created by keyon on 2022/10/12.
//

import UIKit
import Combine

class KYChartBaseView: UIView {

    private var cancelAbles = Set<AnyCancellable>()

    public init() {
        super.init(frame: .zero)
        setup()
        configGesture()
    }

    private func setup() {
        publisher(for: \.bounds, options: .new).sink { [weak self] bounds in
            self?.notifyFrameChanged()
        }.store(in: &cancelAbles)
        publisher(for: \.frame, options: .new).sink { [weak self] frame in
            self?.notifyFrameChanged()
        }.store(in: &cancelAbles)
    }

    private func configGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognized(_:)))
        addGestureRecognizer(tapGestureRecognizer)

        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognized(_:)))
        addGestureRecognizer(panGestureRecognizer)

        let longPressGestureRecoginzer = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureRecognized(_:)))
        addGestureRecognizer(longPressGestureRecoginzer)
    }

    @objc open func tapGestureRecognized(_ recognizer: UITapGestureRecognizer) { }

    @objc open func panGestureRecognized(_ recognizer: UIPanGestureRecognizer) { }

    @objc open func longPressGestureRecognized(_ recognizer: UILongPressGestureRecognizer) { }

    open func notifyFrameChanged() { }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
