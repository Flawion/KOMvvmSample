//
//  BaseLabel.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit

class BaseLabel: UILabel {
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
        textColor = UIColor.Theme.baseLabel
        font = UIFont.Theme.baseLabel
    }
}
