//
//  GameDetailsViewController.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit

final class GameDetailsViewController: BaseViewController {
    private weak var gameDetailsView: GameDetailsView!
    
    let viewModel: GameDetailsViewModel

    init(viewModel: GameDetailsViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let gameDetailView = GameDetailsView(controllerProtocol: self)
        view = gameDetailView
        self.gameDetailsView = gameDetailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }

    private func initialize() {
        prepareNavigationBar(withTitle: viewModel.game.name)
        bindActions(toViewModel: viewModel)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.downloadGameDetailsIfNeed()
    }
    
    override func initializeLoadingView() -> BaseStateView {
        let loadingView = LoadingView()
        gameDetailsView.addViewToDetailsFooter(loadingView)
        return loadingView
    }
    
    override func initializeErrorView() -> BaseStateView {
        let errorView = ErrorView()
        errorView.refreshButtonClicked.asDriver().drive(onNext: { [weak self] in
            self?.viewModel.downloadGameDetailsIfNeed(refresh: true)
        }).disposed(by: disposeBag)
        gameDetailsView.addViewToDetailsFooter(errorView)
        return errorView
    }
}

// MARK: - GameDetailsViewControllerProtocol
extension GameDetailsViewController: GameDetailsViewControllerProtocol {
    func goToDetailsItem(_ detailsItem: GameDetailsItemModel) {
        switch detailsItem.item {
        case .overview:
            viewModel.goToOverviewDetailsItem(detailsItem, navigationController: navigationController)

        case .images:
            viewModel.goToImagesDetailsItem(navigationController: navigationController)

        default:
            break
        }
    }

    func resizeDetailsFooterView() {
        gameDetailsView.resizeDetailsFooterView()
    }
}
