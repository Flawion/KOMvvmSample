//
//  BaseCollectionViewCell.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.Theme.baseCellBackground
        self.contentView.tintColor = UIColor.Theme.baseCellTintColor
        self.selectedBackgroundView = SelectedBackgroundView()
    }
}
