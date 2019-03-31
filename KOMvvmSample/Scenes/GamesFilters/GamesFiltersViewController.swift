//
//  GamesFiltersViewController.swift
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
import KOControls
import RxSwift
import RxCocoa

final class GamesFiltersViewController: BaseViewController {
    // MARK: Variables
    private let platformsSelectedLimit: Int = 5
    private let platformCellReuseIdentifier = "PlatformViewCell"
    private let waitForRefreshPlatformsVar: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    private var refreshPlatformsDisposeBag: DisposeBag!

    private weak var gamesFiltersView: GamesFiltersView!

    let viewModel: GamesFiltersViewModel

    // MARK: View controller functions
    init(currentFilters: [GamesFilters: String]) {
        viewModel = GamesFiltersViewModel(currentFilters: currentFilters)

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initializeView()
        initializeGamesFiltersView()
        initializePlatformsDownloadIndicator()
    }

    private func initializeView() {
        definesPresentationContext = true
        prepareNavigationBar(withTitle: "games_filters_bar_title".localized)
    }

    private func initializeGamesFiltersView() {
        let gamesFiltersView = GamesFiltersView(controllerProtocol: self)
        _ = view.addAutoLayoutSubview(gamesFiltersView)
        self.gamesFiltersView = gamesFiltersView
    }
    
    private func initializePlatformsDownloadIndicator() {
        loadingView.backgroundColor = UIColor.Theme.viewControllerBackground
        Driver<Bool>.combineLatest(waitForRefreshPlatformsVar.asDriver(), PlatformsService.shared.isDownloadingDriver, resultSelector: { (waitForRefreshPlatforms, isDownloadingPlatforms) -> Bool in
            return waitForRefreshPlatforms && isDownloadingPlatforms
            }).drive(loadingView.isActiveVar).disposed(by: disposeBag)
    }
}

// MARK: - GamesFiltersViewControllerProtocol
extension GamesFiltersViewController: GamesFiltersViewControllerProtocol {
    func goBack() {
        navigationController?.popViewController(animated: true)
    }

    func pickNewValue(forFilter filter: GamesFilterModel, refreshCellFunc: @escaping () -> Void) {
        switch filter.filter {
        case .sorting:
            pickSortingOption(forFilter: filter, refreshCellFunc: refreshCellFunc)
            return

        case .originalReleaseDateFrom, .originalReleaseDateTo:
            pickOriginalReleaseDate(forFilter: filter, refreshCellFunc: refreshCellFunc)
            return

        case .platforms:
            pickPlatforms(forFilter: filter, refreshCellFunc: refreshCellFunc)
            return

        default:
            return
        }
    }
}

 // MARK: - Filters pickers
extension GamesFiltersViewController {

    private func pickPlatforms(forFilter filter: GamesFilterModel, refreshCellFunc: @escaping () -> Void) {
        refreshPlatformsDisposeBag = DisposeBag()

        waitForRefreshPlatformsVar.accept(true)
        //refreshes platforms data
        PlatformsService.shared.refreshPlatformsObser
            //checks if error appears
            .catchError({ [weak self](error) -> Observable<Bool> in
                self?.showError(message: error.localizedDescription)
                return Observable<Bool>.just(false)
            })
            .subscribe(onNext: { [weak self](isAvailable) in
                guard let self = self else {
                    return
                }
                self.waitForRefreshPlatformsVar.accept(false)
                guard isAvailable else {
                    return
                }
                //shows platforms picker
                _ = self.presentItemsTablePicker(viewLoadedAction: KODialogActionModel(title: filter.filter.localizable + "\n\(String(format: "games_filters_max_platforms".localized, self.platformsSelectedLimit))", action: { [weak self](dialogViewController) in
                    guard let self = self, let itemsTablePicker = dialogViewController as? KOItemsTablePickerViewController else {
                        return
                    }
                    self.configurePlatformsPicker(itemsTablePicker, forFilter: filter, refreshCellFunc: refreshCellFunc)
                }), postInit: { (dialogViewController) in
                    dialogViewController.contentHeight = 260
                })
            }).disposed(by: refreshPlatformsDisposeBag)
    }

    private func configurePlatformsPicker(_ itemsTablePicker: KOItemsTablePickerViewController, forFilter filter: GamesFilterModel, refreshCellFunc: @escaping () -> Void) {
        //configures platforms picker
        itemsTablePicker.itemsTable.allowsMultipleSelection = true
        itemsTablePicker.itemsTable.separatorStyle = .none
        itemsTablePicker.itemsTable.rowHeight = PlatformViewCell.prefferedListHeight
        itemsTablePicker.itemsTable.register(UINib(nibName: "PlatformViewCell", bundle: nil), forCellReuseIdentifier: platformCellReuseIdentifier)
        itemsTablePicker.rightBarButtonAction = KODialogActionModel.doneAction(withTitle: "games_filters_picker_done_button".localized, action: {[weak self](itemsTablePicker: KOItemsTablePickerViewController) in
            self?.viewModel.selectPlatforms(atIndexes: itemsTablePicker.itemsTable.indexPathsForSelectedRows, forFilter: filter)
            refreshCellFunc()
        })
        itemsTablePicker.leftBarButtonAction = KODialogActionModel.cancelAction(withTitle: "games_filters_picker_cancel_button".localized)

        bindPlatformsPickerData(itemsTablePicker)

        //sets selected platforms
        if let selectedIndexes = viewModel.selectedIndexes(forPlatformsFilter: filter) {
            for selectedIndex in selectedIndexes {
                itemsTablePicker.itemsTable.selectRow(at: selectedIndex, animated: false, scrollPosition: .none)
            }
        }
    }

    private func bindPlatformsPickerData(_ itemsTablePicker: KOItemsTablePickerViewController) {
        PlatformsService.shared.platformsObser.bind(to: itemsTablePicker.itemsTable.rx.items(cellIdentifier: self.platformCellReuseIdentifier)) { _, model, cell in
            (cell as? PlatformViewCell)?.platform = model
            }
            .disposed(by: refreshPlatformsDisposeBag)

        //checks if user select more than count limit, simply will deselect platform above the limit
        itemsTablePicker.itemsTable.rx.itemSelected.asDriver().drive(onNext: { [weak self] indexPath in
            guard let self = self, itemsTablePicker.itemsTable.indexPathsForSelectedRows?.count ?? 0 > self.platformsSelectedLimit else {
                return
            }
            itemsTablePicker.itemsTable.deselectRow(at: indexPath, animated: true)
        }).disposed(by: refreshPlatformsDisposeBag)
    }

    private func pickOriginalReleaseDate(forFilter filter: GamesFilterModel, refreshCellFunc: @escaping () -> Void) {
        _ = presentDatePicker(viewLoadedAction: KODialogActionModel(title: filter.filter.localizable, action: { [weak self] (dialogViewController) in
            guard let datePicker = dialogViewController as? KODatePickerViewController else {
                return
            }
            if let selectedDate = Utils.shared.filterDate(forValue: filter.value) {
                datePicker.datePicker.date = selectedDate
            }
            datePicker.datePicker.datePickerMode = .date
            datePicker.rightBarButtonAction = KODialogActionModel.doneAction(withTitle: "games_filters_picker_done_button".localized, action: { [weak self] (datePicker: KODatePickerViewController) in
                guard let viewModel = self?.viewModel else {
                    return
                }
                filter.value = Utils.shared.filterDateValue(forDate: datePicker.datePicker.date)
                viewModel.refreshDisplayValue(filter)
                refreshCellFunc()
            })
            datePicker.leftBarButtonAction = KODialogActionModel.cancelAction(withTitle: "games_filters_picker_cancel_button".localized)
        }))
    }

    private func pickSortingOption(forFilter filter: GamesFilterModel, refreshCellFunc: @escaping () -> Void) {
        //gets current parameters
        let sortingOptionsDisplayValues = viewModel.availableSortingOptions.compactMap({ $0.displayValue })
        let currentSelectedSortingOptionIndex = viewModel.availableSortingOptions.firstIndex(where: { $0.value == filter.value }) ?? 0

        //shows picker
        _ = presentOptionsPicker(withOptions: [sortingOptionsDisplayValues], viewLoadedAction: KODialogActionModel(title: filter.filter.localizable, action: { (dialogViewController) in

            (dialogViewController as! KOOptionsPickerViewController).optionsPicker.selectRow(currentSelectedSortingOptionIndex, inComponent: 0, animated: false)
            dialogViewController.rightBarButtonAction = KODialogActionModel.doneAction(withTitle: "games_filters_picker_done_button".localized, action: { [weak self](optionsPicker: KOOptionsPickerViewController) in
                guard let self = self else {
                    return
                }
                //sets new value
                let selectedSortingOptionIndex = optionsPicker.optionsPicker.selectedRow(inComponent: 0)
                let selectedSortingOption = self.viewModel.availableSortingOptions[selectedSortingOptionIndex]
                filter.value = selectedSortingOption.value
                filter.displayValue = selectedSortingOption.displayValue
                refreshCellFunc()
            })
            dialogViewController.leftBarButtonAction = KODialogActionModel.cancelAction(withTitle: "games_filters_picker_cancel_button".localized)

        }))
    }
}
