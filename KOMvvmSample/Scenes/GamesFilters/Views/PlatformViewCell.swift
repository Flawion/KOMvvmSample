//
//  PlatformViewCell.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit

final class PlatformViewCell: BaseTableViewCell {
    @IBOutlet weak var platformImageView: UIImageView!
    @IBOutlet weak var titleLabel: CellTitleLabel!
    @IBOutlet weak var descLabel: BaseLabel!

    static var prefferedListHeight: CGFloat {
        return 96
    }

    var platform: PlatformModel? {
        didSet {
            refreshPlatform()
        }
    }
    
    private func refreshPlatform() {
        titleLabel.text = platform?.name
        descLabel.text = platform?.deck
        if let image = platform?.image?.mediumUrl {
            platformImageView.setImageFade(url: image)
        } else {
            platformImageView.sd_cancelCurrentImageLoad()
        }
    }
}
