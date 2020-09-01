//
//  GamesView.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit
import RxCocoa
import RxSwift

final class GamesView: UIView {
    
    private weak var controllerProtocol: GamesViewControllerProtocol?

    //collections view
    private weak var gamesCollectionView: UICollectionView!
    private var gamesListLayout: UICollectionViewFlowLayout!
    private var gamesCollectionLayout: UICollectionViewFlowLayout!

    private weak var gamesCollectionRefreshControl: UIRefreshControl!

    private let gameCellReuseIdentifier: String = "GameViewCell"
    private var gamesCollectionViewSize: CGSize = CGSize(width: 0, height: 0)
    private var isGamesListLayout: Bool = true

    private let disposeBag: DisposeBag = DisposeBag()

    // MARK: Initialization
    init(controllerProtocol: GamesViewControllerProtocol) {
        self.controllerProtocol = controllerProtocol
        super.init(frame: CGRect.zero)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        initializeGamesCollectionView()
        initializeGamesCollectionInfinityScrolling()
        initializeGamesCollectionRefreshControl()
    }

    // MARK: Games collection functions
    private func initializeGamesCollectionView() {
        gamesListLayout = UICollectionViewFlowLayout()
        gamesCollectionLayout = UICollectionViewFlowLayout()

        //creates collection view
        let gamesCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: gamesListLayout)
        gamesCollectionView.register(UINib(nibName: "GameViewCell", bundle: nil), forCellWithReuseIdentifier: gameCellReuseIdentifier)
        gamesCollectionView.backgroundColor = UIColor.Theme.gamesCollectionBackground
        gamesCollectionView.alwaysBounceVertical = true
        _ = addSafeAutoLayoutSubview(gamesCollectionView, overrideAnchors: AnchorsContainer(top: topAnchor))

        self.gamesCollectionView = gamesCollectionView
        bindGamesCollection()
    }

    private func bindGamesCollection() {
        bindGamesCollectionItemSelected()
        bindGamesCollectionData()
        bindGamesCollectionBottomInsetToKeyboardHeight()
    }

    private func bindGamesCollectionItemSelected() {
        gamesCollectionView.rx.itemSelected.asDriver().drive(onNext: { [weak self] indexPath in
            guard let self = self else {
                return
            }
            self.goToGameDetail(atIndexPath: indexPath)
            self.gamesCollectionView.deselectItem(at: indexPath, animated: true)
        }).disposed(by: disposeBag)
    }

    private func bindGamesCollectionData() {
        controllerProtocol?.viewModel.gamesDriver.drive(gamesCollectionView.rx.items(cellIdentifier: gameCellReuseIdentifier)) { _, model, cell in
            (cell as? GameViewCell)?.game = model
            }
            .disposed(by: disposeBag)
    }

    private func bindGamesCollectionBottomInsetToKeyboardHeight() {
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .subscribe(onNext: { [weak self] notification in
                guard let self = self, let userInfo = notification.userInfo,
                    let rect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
                        return
                }
                self.setGamesCollectionBottomInset(rect.height)
            }).disposed(by: disposeBag)

        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .subscribe(onNext: { [weak self] _ in
                self?.setGamesCollectionBottomInset(0)
            }).disposed(by: disposeBag)
    }

    private func setGamesCollectionBottomInset(_ inset: CGFloat) {
        self.gamesCollectionView.contentInset.bottom = inset
        self.gamesCollectionView.scrollIndicatorInsets.bottom = self.gamesCollectionView.contentInset.bottom
    }

    // MARK: Infinity scrolling functions
    private func initializeGamesCollectionInfinityScrolling() {
        let infiniteScrollIndicatorView = UIActivityIndicatorView(style: .gray)
        infiniteScrollIndicatorView.color = UIColor.Theme.gamesCollectionInfiniteScrollIndicator
        gamesCollectionView.infiniteScrollIndicatorView = infiniteScrollIndicatorView
        
        gamesCollectionView.addInfiniteScroll { [weak self] _ -> Void in
            self?.controllerProtocol?.viewModel.searchMore()
        }

        gamesCollectionView.setShouldShowInfiniteScrollHandler { [weak self] _ -> Bool in
            self?.controllerProtocol?.viewModel.canDownloadMoreResults ?? false
        }

        bindGamesCollectionInfinityScrollingHidding()
    }

    private func bindGamesCollectionInfinityScrollingHidding() {
        controllerProtocol?.viewModel.dataActionStateDriver.map({ $0 == .loadingMore }).drive(onNext: { [weak self] isLoadingMore in
            guard let self = self, !isLoadingMore, self.gamesCollectionView.isAnimatingInfiniteScroll else {
                return
            }
            self.gamesCollectionView.setNeedsLayout()
            self.gamesCollectionView.layoutIfNeeded()
            self.gamesCollectionView.finishInfiniteScroll()
        }).disposed(by: disposeBag)
    }

    // MARK: Refreshing functions
    private func initializeGamesCollectionRefreshControl() {
        let gamesCollectionRefreshControl = UIRefreshControl()
        gamesCollectionRefreshControl.addTarget(self, action: #selector(gamesCollectionStartRefreshing), for: .valueChanged)
        gamesCollectionView.addSubview(gamesCollectionRefreshControl)
        self.gamesCollectionRefreshControl = gamesCollectionRefreshControl
        bindGamesCollectionRefreshControlHidding()
    }

    @objc private func gamesCollectionStartRefreshing() {
        controllerProtocol?.viewModel.searchIfNeed(force: true)
    }

    private func bindGamesCollectionRefreshControlHidding() {
        controllerProtocol?.viewModel.dataActionStateDriver.map({ $0 == .loading }).drive(onNext: { [weak self] isLoading in
            guard let self = self, !isLoading, self.gamesCollectionRefreshControl.isRefreshing else {
                return
            }
            self.gamesCollectionRefreshControl.endRefreshing()
        }).disposed(by: disposeBag)
    }

    // MARK: Resizing functions
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async { [weak self] in
            self?.resizeGamesCollectionView()
        }
    }

    private func resizeGamesCollectionView() {
        let collectionSize = gamesCollectionView.bounds.size
        
        guard collectionSize.width > 0 && collectionSize.height > 0 && collectionSize != gamesCollectionViewSize else {
            return
        }

        resizeGamesListLayout(collectionSize: collectionSize)
        resizeGamesCollectionLayout(collectionSize: collectionSize)
        gamesCollectionViewSize = collectionSize
    }

    private func resizeGamesListLayout(collectionSize size: CGSize) {
        gamesListLayout.sectionInset = UIEdgeInsets.zero
        gamesListLayout.minimumLineSpacing = 0
        gamesListLayout.itemSize = CGSize(width: size.width, height: GameViewCell.prefferedListHeight)
        gamesListLayout.invalidateLayout()
    }

    private func resizeGamesCollectionLayout(collectionSize size: CGSize) {
        let itemMinWidth: Double = Double(GameViewCell.prefferedCollectionWidth)
        let inset: CGFloat = 4
        let itemMargin = 2.0
        let parentWidth = Double((size.width) - inset * 2)
        let divider = max(2.0, (Double(parentWidth)) / itemMinWidth)
        let column = floor(divider)
        let allMargin = (itemMargin * (column - 1))
        let itemSize = (Double(parentWidth) / column) - allMargin
        let lineSpacing = max(4.0, ((Double(parentWidth) - allMargin) - (column * itemSize)) / column)

        gamesCollectionLayout.minimumInteritemSpacing = CGFloat(itemMargin) * 2
        gamesCollectionLayout.minimumLineSpacing = CGFloat(lineSpacing)
        gamesCollectionLayout.itemSize = CGSize(width: itemSize, height: itemSize + Double(GameViewCell.prefferedCollectionHeight - GameViewCell.prefferedCollectionWidth))
        gamesCollectionLayout.sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        gamesCollectionLayout.invalidateLayout()
    }

    // MARK: Changing layout mode functions
    func refreshChangingLayoutBarButton() {
        guard let gamesViewController = controllerProtocol else {
            return
        }
        isGamesListLayout ? gamesViewController.addBarCollectionLayoutButton() : gamesViewController.addBarListLayoutButton()
    }

    @objc func swipeGamesCollectionLayout() {
        isGamesListLayout = !isGamesListLayout
        gamesCollectionView.setCollectionViewLayout(isGamesListLayout ? gamesListLayout : gamesCollectionLayout, animated: true)
        gamesCollectionView.reloadData()
        refreshChangingLayoutBarButton()
    }

    // MARK: Others functions
    private func goToGameDetail(atIndexPath indexPath: IndexPath) {
        guard let gamesViewController = controllerProtocol, let game = gamesViewController.viewModel.game(atIndex: indexPath.row) else {
            return
        }
        gamesViewController.goToGameDetail(game)
    }
}
