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
    private weak var controllerProtocol: UIGameImagesViewControllerProtocol?

    private let cellReuseIdentifier: String = "GameImageViewCell"
    private weak var collectionView: UICollectionView!
    private let disposeBag = DisposeBag()

    // MARK: Initialization
    init(controllerProtocol: UIGameImagesViewControllerProtocol?) {
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
        let layout = CollectionLayout(preferredCellSize: GameImageViewCell.preferredCollectionSize)
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
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
}
