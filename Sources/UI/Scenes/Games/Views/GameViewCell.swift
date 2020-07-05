//
//  GameViewCell.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit
import SDWebImage

final class GameViewCell: BaseCollectionViewCell {
    // MARK: Variables
    //controls
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: CellTitleLabel!
    @IBOutlet weak var collectionTitleLabel: CellSmallTitleLabel!
    @IBOutlet weak var descLabel: BaseLabel!

    @IBOutlet weak var collectionContentView: UIView!
    @IBOutlet weak var listContentView: UIView!

    //constraints
    @IBOutlet weak var imageWidthConst: NSLayoutConstraint!
    @IBOutlet weak var imageTrailingToContentConst: NSLayoutConstraint!
    @IBOutlet weak var imageTrailingToCellConst: NSLayoutConstraint!
    @IBOutlet weak var contentLeadingToCellConst: NSLayoutConstraint!

    static var prefferedListHeight: CGFloat {
        return 96
    }

    static var prefferedCollectionWidth: CGFloat {
        return 96
    }

    static var prefferedCollectionHeight: CGFloat {
        return 136
    }

    var isListLayout: Bool = true {
        didSet {
            isListLayout ? changeLayoutToList() : changeLayoutToCollection()
            layoutIfNeeded()
        }
    }

    var game: GameModel? {
        didSet {
           refreshGame()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if let superView = superview {
            isListLayout = bounds.width == superView.bounds.width
        }
    }
    
    private func changeLayoutToList() {
        imageWidthConst.priority = UILayoutPriority(999)
        imageTrailingToContentConst.priority = UILayoutPriority(999)
        imageTrailingToCellConst.priority = UILayoutPriority(1)
        contentLeadingToCellConst.priority = UILayoutPriority(1)
        collectionContentView.isHidden = true
        listContentView.isHidden = false
    }
    
    private func changeLayoutToCollection() {
        imageWidthConst.priority = UILayoutPriority(1)
        imageTrailingToContentConst.priority = UILayoutPriority(1)
        imageTrailingToCellConst.priority = UILayoutPriority(999)
        contentLeadingToCellConst.priority = UILayoutPriority(999)
        collectionContentView.isHidden = false
        listContentView.isHidden = true
    }
    
    private func refreshGame() {
        titleLabel.text = game?.name
        collectionTitleLabel.text = game?.name
        descLabel.text = game?.deck
        imageView.image = nil
        if let image = game?.image?.mediumUrl {
            imageView.setImageFade(url: image)
        } else {
            imageView.sd_cancelCurrentImageLoad()
        }
    }
}