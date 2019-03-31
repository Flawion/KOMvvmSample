//
//  GamesFiltersView.swift
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

final class GamesFiltersView: UIView {
    private weak var controllerProtocol: GamesFiltersViewControllerProtocol?

    private weak var saveView: UIView!
    private weak var filtersTableView: UITableView!
    private let gameFilterCellReuseIdentifier: String = "GamesFilterViewCell"

    private let disposeBag: DisposeBag = DisposeBag()

    // MARK: Initialization
    init(controllerProtocol: GamesFiltersViewControllerProtocol) {
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
        initializeFiltersTableView()
    }

    private func initializeSaveView() {
        let saveView = UIView()
        _ = addSafeAutoLayoutSubview(saveView, toAddConstraints: [.left, .right, .bottom])
        self.saveView = saveView

        let saveButton = ConfirmButton()
        saveButton.setTitle("Save filters", for: .normal)
        _ = saveView.addAutoLayoutSubview(saveButton, insets: UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12), priorities: [.useForAll: 999])
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
        _ = addSafeAutoLayoutSubview(filtersTableView, overrideAnchors: OverrideAnchors(top: topAnchor, bottom: saveView.topAnchor))
        filtersTableView.tableFooterView = UIView()
        self.filtersTableView = filtersTableView

        bindFiltersTableData()
    }

    private func bindFiltersTableData() {
        //binds item selected
        filtersTableView.rx.itemSelected.asDriver().drive(onNext: { [weak self] indexPath in
            guard let self = self else {
                return
            }
            self.changeFilterValue(atIndexPath: indexPath)
            self.filtersTableView.deselectRow(at: indexPath, animated: true)
        }).disposed(by: disposeBag)

        //binds data
        controllerProtocol?.viewModel.filtersObser.bind(to: filtersTableView.rx.items(cellIdentifier: gameFilterCellReuseIdentifier)) { [weak self] _, model, cell in
            let gamesFilterViewCell = cell as! GamesFilterViewCell
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
        controllerProtocol?.viewModel.refreshDisplayValue(clearFilter)
        if let indexPath = filtersTableView.indexPath(for: viewCell) {
            filtersTableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}
