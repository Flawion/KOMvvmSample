//
//  ConfirmButton.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit

final class ConfirmButton: BaseButton {
    override func initialize() {
        super.initialize()
        backgroundColor = UIColor.Theme.confirmButtonBackground
        contentEdgeInsets = UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 8)
        setTitleColor(UIColor.Theme.confirmButtonTitle, for: .normal)
        titleLabel?.font = UIFont.Theme.confirmButton
        layer.cornerRadius = 4
    }
}
