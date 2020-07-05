//
//  GameImagesView.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

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

    private func initialize() {
        initializeCollectionView()
    }

    // MARK: Game images collection functions
    private func initializeCollectionView() {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(UINib(nibName: "GameImageViewCell", bundle: nil), forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView.backgroundColor = UIColor.Theme.gamesCollectionBackground
        collectionView.alwaysBounceVertical = true
        _ = addSafeAutoLayoutSubview(collectionView, overrideAnchors: AnchorsContainer(top: topAnchor))

        self.collectionView = collectionView
        bindCollection()
    }

    private func bindCollection() {
        bindCollectionData()
        bindCollectionItemSelected()
    }

    private func bindCollectionData() {
        controllerProtocol?.viewModel.imagesObservable.bind(to: collectionView.rx.items(cellIdentifier: cellReuseIdentifier)) { _, model, cell in
            (cell as? GameImageViewCell)?.image = model
            }
            .disposed(by: disposeBag)
    }

    private func bindCollectionItemSelected() {
        collectionView.rx.itemSelected.asDriver().drive(onNext: { [weak self] indexPath in
            guard let self = self else {
                return
            }
            self.goToImageViewer(forImageAtIndexPath: indexPath)
            self.collectionView.deselectItem(at: indexPath, animated: true)
        }).disposed(by: disposeBag)
    }

    private func goToImageViewer(forImageAtIndexPath indexPath: IndexPath) {
        guard let controllerProtocol = controllerProtocol, let image = controllerProtocol.viewModel.getImage(forIndexPath: indexPath) else {
            return
        }
        controllerProtocol.goToImageViewer(forImage: image)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        resizeGamesCollectionView()
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
}