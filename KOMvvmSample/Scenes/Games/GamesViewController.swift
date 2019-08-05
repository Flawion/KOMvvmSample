//
//  GamesViewController.swift
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

// MARK: - Class methods and intializations
final class GamesViewController: BaseViewController {
    // MARK: Variables
    private weak var gamesView: GamesView!
    private weak var searchController: UISearchController!

    let viewModel: GamesViewModel

    // MARK: View controller functions
    init(viewModel: GamesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
        guard let gamesFiltersControllerProtocol = AppCoordinator.shared.transition(.push(onNavigationController: navigationController), toScene: GamesFiltersSceneBuilder(currentFilters: viewModel.gamesFilters)) as? GamesFiltersViewControllerProtocol else {
            fatalError("cast failed GamesFiltersViewControllerProtocol")
        }
        gamesFiltersControllerProtocol.viewModel.savedFiltersObser.subscribe(onNext: { [weak self] savedFilters in
            self?.viewModel.changeGameFilters(savedFilters)
        }).disposed(by: gamesFiltersControllerProtocol.disposeBag)
    }

    private func initializeActions() {
        bindActions(toViewModel: viewModel)
        bindActionToRefreshButtonClicked()
    }

    private func bindActionToRefreshButtonClicked() {
        (errorView as? ErrorView)?.refreshButtonClicked.asDriver().drive(onNext: { [weak self] in
            self?.viewModel.searchGamesIfNeed(forceRefresh: true)
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
            .debounce(0.5)
            .drive(onNext: { [weak self] _ in
                guard let self = self else {
                    return
                }
                self.viewModel.changeGameFilters([ .name: self.searchController.searchBar.text])
            }).disposed(by: disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.searchGamesIfNeed()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //checks api key
        if AppSettings.Api.key.isEmpty {
            showError(message: "error_api_key".localized)
        }
    }
}

// MARK: - GamesViewControllerProtocol
extension GamesViewController: GamesViewControllerProtocol {
    func addBarListLayoutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "list")?.withRenderingMode(.alwaysTemplate), style: .plain, target: gamesView, action: #selector(gamesView.swipeGamesCollectionLayout))
    }

    func addBarCollectionLayoutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "collection")?.withRenderingMode(.alwaysTemplate), style: .plain, target: gamesView, action: #selector(gamesView.swipeGamesCollectionLayout))
    }

    func goToGameDetail(_ game: GameModel) {
        _ = AppCoordinator.shared.transition(.push(onNavigationController: navigationController), toScene: GameDetailsSceneBuilder(game: game))
    }
}
