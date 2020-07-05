//
//  GameImageViewCell.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit

final class GameImageViewCell: BaseCollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!

    static var prefferedCollectionWidth: CGFloat {
        return 160
    }

    static var prefferedCollectionHeight: CGFloat {
        return 160
    }

    var image: ImageModel? {
        didSet {
           refreshImage()
        }
    }
    
    private func refreshImage() {
        if let image = image?.mediumUrl {
            imageView.setImageFade(url: image)
        } else {
            imageView.sd_cancelCurrentImageLoad()
        }
    }
}