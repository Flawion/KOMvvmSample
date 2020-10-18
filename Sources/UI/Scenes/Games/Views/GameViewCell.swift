//
//  GameViewCell.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit
import SDWebImage
import RxSwift
import RxCocoa
import KOMvvmSampleLogic

final class GameViewCell: BaseCollectionViewCell {
    // MARK: Variables
    private let disposeBag = DisposeBag()
    private let minListLayoutCellWidth: CGFloat = 300
    private var layoutRefreshedForWidth: CGFloat = 0
    
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
    
    private var isListLayout: Bool = true {
        didSet {
            isListLayout ? changeLayoutToList() : changeLayoutToCollection()
            layoutIfNeeded()
            layoutRefreshedForWidth = bounds.width
        }
    }
    
    static var prefferedListHeight: CGFloat {
        return 96
    }
    
    static var prefferedCollectionWidth: CGFloat {
        return 118
    }
    
    static var prefferedCollectionHeight: CGFloat {
        return 158
    }
    
    var game: GameModel? {
        didSet {
            refreshGame()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bindCellSize()
    }
    
    private func bindCellSize() {
        rx.observe(CGRect.self, "bounds")
            .asDriver(onErrorJustReturn: nil).map({ $0?.size.width ?? 0 })
            .filter({ [weak self] size -> Bool in
                size != self?.layoutRefreshedForWidth
            })
            .drive(onNext: { [weak self] width in
                self?.resizeCell(toWidth: width)
            }).disposed(by: disposeBag)
    }
    
    private func resizeCell(toWidth width: CGFloat) {
        isListLayout = width >= minListLayoutCellWidth
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
