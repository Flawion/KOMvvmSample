//
//  IconButton.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit

final class IconButton: BaseButton {
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 40, height: 40)
    }

    override func initialize() {
        super.initialize()
        imageView?.contentMode = .center
    }
}
