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
    private weak var collectionView: UICollectionView!
    private var collectionResizedForWidth: CGFloat = 0

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
        bindCollectionSize()
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

    private func bindCollectionSize() {
        collectionView.rx.observe(CGRect.self, "bounds")
            .asDriver(onErrorJustReturn: nil).map({ $0?.size.width ?? 0 })
            .filter({ [weak self] width -> Bool in
                width != self?.collectionResizedForWidth
            })
            .drive(onNext: { [weak self] width in
                self?.resizeCollection(toWidth: width)
            }).disposed(by: disposeBag)
    }
    
    private func resizeCollection(toWidth width: CGFloat) {
        guard let collectionLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        let itemMinWidth = GameImageViewCell.prefferedCollectionWidth
        let itemMargin: CGFloat = 4
        let inset: CGFloat = 4
        let parentWidth = width - inset * 2
        let divider = max(2.0, parentWidth / (itemMinWidth + (itemMargin * 0.5)))
        let column = floor(divider)
        let allMargins = itemMargin * (column - 1)
        let marginedParentWidth = parentWidth - allMargins
        let itemSize = marginedParentWidth / column
     
        collectionLayout.minimumInteritemSpacing = itemMargin
        collectionLayout.minimumLineSpacing = itemMargin
        collectionLayout.itemSize = CGSize(width: itemSize, height: itemSize)
        collectionLayout.sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        collectionLayout.invalidateLayout()
        collectionResizedForWidth = width
    }
    
    func invalidateCollectionLayout() {
        collectionView.collectionViewLayout.invalidateLayout()
    }
}
