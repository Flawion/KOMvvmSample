//
//  SeparatorLineView.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit

final class SeparatorLineView: UIView {
    private weak var separatorColorLayer: CALayer!

    var seperatorColor: UIColor = UIColor.Theme.separatorLine {
        didSet {
            refreshSeparatorColor()
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

    override func layoutSubviews() {
        super.layoutSubviews()
        refreshSeparatorFrame()
    }

    private func initialize() {
        let separatorColorLayer = CALayer()
        separatorColorLayer.needsDisplayOnBoundsChange = true
        self.separatorColorLayer = separatorColorLayer
        layer.addSublayer(separatorColorLayer)
        refreshSeparatorColor()
        refreshSeparatorFrame()
    }

    private func refreshSeparatorColor() {
        separatorColorLayer.backgroundColor = seperatorColor.cgColor
    }

    private func refreshSeparatorFrame() {
        separatorColorLayer.frame = bounds
    }
}
