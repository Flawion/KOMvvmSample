//
//  GamesFiltersView.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit
import RxSwift
import RxCocoa
import KOMvvmSampleLogic

final class GamesFiltersView: UIView {
    private weak var controllerProtocol: UIGamesFiltersViewControllerProtocol?

    private weak var saveView: UIView!
    private weak var filtersTableView: UITableView!
    private let gameFilterCellReuseIdentifier: String = "GamesFilterViewCell"

    private let disposeBag: DisposeBag = DisposeBag()

    // MARK: Initialization
    init(controllerProtocol: UIGamesFiltersViewControllerProtocol) {
        self.controllerProtocol = controllerProtocol
        super.init(frame: CGRect.zero)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    private func initialize() {
        initializeSaveView()
        initializeSaveButton()
        initializeFiltersTableView()
    }

    private func initializeSaveView() {
        let saveView = UIView()
        _ = addSafeAutoLayoutSubview(saveView, toAddConstraints: [.left, .right, .bottom])
        self.saveView = saveView
    }

    private func initializeSaveButton() {
        let saveButton = ConfirmButton()
        saveButton.setTitle("Save filters", for: .normal)
        _ = saveView.addAutoLayoutSubview(saveButton, settings: AddAutoLayoutSubviewSettings(insets: UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12), priorities: [.useForAll: 999]))
        saveButton.addTarget(self, action: #selector(saveButtonClicked), for: .touchUpInside)
    }

    @objc private func saveButtonClicked() {
        guard let controllerProtocol = controllerProtocol else {
            return
        }
        controllerProtocol.viewModel.saveFilters()
        controllerProtocol.goBack()
    }

    private func initializeFiltersTableView() {
        let filtersTableView = UITableView()
        filtersTableView.separatorStyle = .none
        filtersTableView.register(UINib(nibName: "GamesFilterViewCell", bundle: nil), forCellReuseIdentifier: gameFilterCellReuseIdentifier)
        _ = addSafeAutoLayoutSubview(filtersTableView, overrideAnchors: AnchorsContainer(top: topAnchor, bottom: saveView.topAnchor))
        filtersTableView.tableFooterView = UIView()
        self.filtersTableView = filtersTableView

        bindFiltersItemSelected()
        bindFiltersTableData()
    }

    private func bindFiltersItemSelected() {
        filtersTableView.rx.itemSelected.asDriver().drive(onNext: { [weak self] indexPath in
            guard let self = self else {
                return
            }
            self.changeFilterValue(atIndexPath: indexPath)
            self.filtersTableView.deselectRow(at: indexPath, animated: true)
        }).disposed(by: disposeBag)

    }

    private func bindFiltersTableData() {
        controllerProtocol?.viewModel.filtersObservable.bind(to: filtersTableView.rx.items(cellIdentifier: gameFilterCellReuseIdentifier)) { [weak self] _, model, cell in
            guard let gamesFilterViewCell = cell as? GamesFilterViewCell else {
                fatalError("cast failed GamesFilterViewCell")
            }
            gamesFilterViewCell.filter = model
            gamesFilterViewCell.delegate = self
            }
            .disposed(by: disposeBag)
    }

    private func changeFilterValue(atIndexPath indexPath: IndexPath) {
        guard let controllerProtocol = controllerProtocol, let filter = controllerProtocol.viewModel.filter(atIndexPath: indexPath) else {
            return
        }
        controllerProtocol.pickNewValue(forFilter: filter, refreshCellFunc: { [weak self] in
            guard let self = self else {
                return
            }
            self.filtersTableView.reloadRows(at: [indexPath], with: .none)
        })
    }
}

extension GamesFiltersView: GamesFilterViewCellDelegate {
    func gamesFilter(viewCell: UITableViewCell, clearFilter: GamesFilterModel) {
        clearFilter.value = ""
        controllerProtocol?.viewModel.refreshDisplayValue(forFilter: clearFilter)
        if let indexPath = filtersTableView.indexPath(for: viewCell) {
            filtersTableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}
