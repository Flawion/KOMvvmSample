//
//  GameDetailsViewController.swift
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
            goToOverviewDetailsItem(detailsItem)

        case .images:
            goToImagesDetailsItem(detailsItem)

        default:
            break
        }
    }

    private func goToOverviewDetailsItem(_ detailsItem: GameDetailsItemModel) {
        _ = AppCoordinator.shared.transition(.push(scene: WebViewControllerSceneBuilder(barTitle: detailsItem.localizedName, html: viewModel.game.description ?? ""), onNavigationController: navigationController))
    }

    private func goToImagesDetailsItem(_ detailsItem: GameDetailsItemModel) {
        guard let images = viewModel.gameDetails?.images else {
            return
        }
        _ = AppCoordinator.shared.transition(.push(scene: GameImagesSceneBuilder(images: images), onNavigationController: navigationController))
    }

    func resizeDetailsFooterView() {
        gameDetailsView.resizeDetailsFooterView()
    }
}
