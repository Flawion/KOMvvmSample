//
//  GamesViewController.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit
import RxSwift
import RxCocoa
import KOMvvmSampleLogic

// MARK: - Class methods and intializations
final class GamesViewController: BaseViewController<GamesViewModelProtocol>, GamesViewControllerProtocol {
    // MARK: Variables
    private weak var gamesView: GamesView!
    private weak var searchController: UISearchController!

    // MARK: View controller functions
    override func loadView() {
        let gamesView: GamesView = GamesView(controllerProtocol: self)
        view = gamesView
        self.gamesView = gamesView
        
        gamesView.refreshChangingLayoutBarButton()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }

    private func initialize() {
        initializeView()
        initializeActions()
        initializeSearchBar()
    }

    private func initializeView() {
        prepareNavigationBar(withTitle: "games_bar_title".localized)
        addBarFilterButton()
    }

    private func addBarFilterButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "filter"), style: .plain, target: self, action: #selector(goToGamesFilter))
    }

    @objc private func goToGamesFilter() {
        viewModel.goToGamesFilter(navigationController: navigationController)
    }

    private func initializeActions() {
        bindActions(toViewModel: viewModel)
        bindActionToRefreshButtonClicked()
    }

    private func bindActionToRefreshButtonClicked() {
        (errorView as? ErrorView)?.refreshButtonClicked.asDriver().drive(onNext: { [weak self] in
            self?.viewModel.searchIfNeed(force: true)
        }).disposed(by: disposeBag)
    }

    private func initializeSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.tintColor = UIColor.Theme.barTint
        searchController.searchBar.placeholder = "games_search_bar_placeholder".localized
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        self.searchController = searchController

        bindSearchBarToGamesFilters()
    }

    private func bindSearchBarToGamesFilters() {
        Driver<Void>.merge([
            searchController.searchBar.rx.cancelButtonClicked.asDriver().map({ () }),
            searchController.searchBar.rx.text.asDriver(onErrorJustReturn: nil).map({ _ in () })
            ])
            .debounce(.milliseconds(500))
            .drive(onNext: { [weak self] _ in
                guard let self = self else {
                    return
                }
                self.viewModel.change(filters: [ .name: self.searchController.searchBar.text])
            }).disposed(by: disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.searchIfNeed()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // checks api key
        if !viewModel.isApiKeyValid {
            showError(message: "error_api_key".localized)
        }
    }
}

// MARK: - UIGamesViewControllerProtocol
extension GamesViewController: UIGamesViewControllerProtocol {
    func addBarListLayoutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "list")?.withRenderingMode(.alwaysTemplate), style: .plain, target: gamesView, action: #selector(gamesView.swipeGamesCollectionLayout))
    }

    func addBarCollectionLayoutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "collection")?.withRenderingMode(.alwaysTemplate), style: .plain, target: gamesView, action: #selector(gamesView.swipeGamesCollectionLayout))
    }

    func goToGameDetail(_ game: GameModel) {
        viewModel.goToGameDetail(game, navigationController: navigationController)
    }
}
