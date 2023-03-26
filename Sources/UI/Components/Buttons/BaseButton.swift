//
//  BaseButton.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit

class BaseButton: UIButton {

    override var isHighlighted: Bool {
        didSet {
            runHighlightedAnimation()
        }
    }

    // MARK: Initialization
    convenience init() {
        self.init(frame: CGRect.zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    // to override
    func initialize() {

    }

    private func runHighlightedAnimation() {
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            guard let self = self else {
                return
            }
            self.alpha = self.isHighlighted ? 0.5 : 1.0
        })
    }
}
