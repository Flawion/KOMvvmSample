//
//  GameDetailsItemViewCell.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit

final class GameDetailsItemViewCell: BaseTableViewCell {
    @IBOutlet weak var titleLabel: CellTitleLabel!

    static var prefferedHeight: CGFloat {
        return 44
    }

    var gameDetailsItem: GameDetailsItemModel? {
        didSet {
            titleLabel.text = gameDetailsItem?.localizedName
        }
    }
}
