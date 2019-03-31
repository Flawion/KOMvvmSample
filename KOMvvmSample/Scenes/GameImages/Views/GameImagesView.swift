//
//  GameImagesView.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import UIKit
import RxSwift
import RxCocoa

final class GameImagesView: UIView {
    // MARK: Variables
    private weak var controllerProtocol: GameImagesViewControllerProtocol?

    private let cellReuseIdentifier: String = "GameImageViewCell"
    private var collectionViewSize: CGSize = CGSize(width: 0, height: 0)
    private weak var collectionView: UICollectionView!

    private let disposeBag = DisposeBag()

    // MARK: Initialization
    init(controllerProtocol: GameImagesViewControllerProtocol?) {
        self.controllerProtocol = controllerProtocol
        super.init(frame: CGRect.zero)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        resizeGamesCollectionView()
    }

    private func initialize() {
        initializeCollectionView()
    }

    // MARK: Game images collection functions
    //private
    private func initializeCollectionView() {
        //creates collection view
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(UINib(nibName: "GameImageViewCell", bundle: nil), forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView.backgroundColor = UIColor.Theme.gamesCollectionBackground
        collectionView.alwaysBounceVertical = true
        _ = addSafeAutoLayoutSubview(collectionView, overrideAnchors: OverrideAnchors(top: topAnchor))

        self.collectionView = collectionView
        bindCollectionData()
    }

    private func bindCollectionData() {
        //binds data
        controllerProtocol?.viewModel.imagesObser.bind(to: collectionView.rx.items(cellIdentifier: cellReuseIdentifier)) { _, model, cell in
            (cell as! GameImageViewCell).image = model
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected.asDriver().drive(onNext: { [weak self] indexPath in
            guard let self = self else {
                return
            }
            self.goToImageViewer(forImageAtIndexPath: indexPath)
            self.collectionView.deselectItem(at: indexPath, animated: true)
        }).disposed(by: disposeBag)
    }

    private func resizeGamesCollectionView() {
        let size = collectionView.bounds.size

        guard let collectionLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout, size.width > 0, size.height > 0, size != collectionViewSize else {
            return
        }

        //resizes collection layout
        let itemMinWidth: Double = Double(GameImageViewCell.prefferedCollectionWidth)
        let inset: CGFloat = 4
        let itemMargin = 2.0
        let parentWidth = Double((size.width) - inset * 2)
        let divider = max(2.0, (Double(parentWidth)) / itemMinWidth)
        let column = floor(divider)
        let allMargin = (itemMargin * (column - 1))
        let itemSize = (Double(parentWidth) / column) - allMargin
        let lineSpacing = max(4.0, ((Double(parentWidth) - allMargin) - (column * itemSize)) / column)

        collectionLayout.minimumInteritemSpacing = CGFloat(itemMargin) * 2
        collectionLayout.minimumLineSpacing = CGFloat(lineSpacing)
        collectionLayout.itemSize = CGSize(width: itemSize, height: itemSize + Double(GameImageViewCell.prefferedCollectionHeight - GameImageViewCell.prefferedCollectionWidth))
        collectionLayout.sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        collectionLayout.invalidateLayout()

        collectionViewSize = size
    }
    
    private func goToImageViewer(forImageAtIndexPath indexPath: IndexPath) {
        guard let controllerProtocol = controllerProtocol, let image = controllerProtocol.viewModel.getImage(forIndexPath: indexPath) else {
            return
        }
        controllerProtocol.goToImageViewer(forImage: image)
    }
}
