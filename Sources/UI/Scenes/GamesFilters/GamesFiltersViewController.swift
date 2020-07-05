//
//  GamesFiltersViewController.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit
import KOControls
import RxSwift
import RxCocoa

final class GamesFiltersViewController: BaseViewController<GamesFiltersViewModelProtocol> {
    // MARK: Variables
    private let platformsSelectedLimit: Int = 5
    private let platformCellReuseIdentifier = "PlatformViewCell"
    private let waitForRefreshPlatformsRelay: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    private var refreshPlatformsDisposeBag: DisposeBag!

    private weak var gamesFiltersView: GamesFiltersView!

    // MARK: View controller functions
    override func loadView() {
        let gamesFiltersView = GamesFiltersView(controllerProtocol: self)
        view = gamesFiltersView
        self.gamesFiltersView = gamesFiltersView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }

    private func initialize() {
        initializeView()
        initializePlatformsDownloadIndicator()
    }

    private func initializeView() {
        definesPresentationContext = true
        prepareNavigationBar(withTitle: "games_filters_bar_title".localized)
    }

    private func initializePlatformsDownloadIndicator() {
        loadingView.backgroundColor = UIColor.Theme.viewControllerBackground
        Driver<Bool>.combineLatest(waitForRefreshPlatformsRelay.asDriver(), viewModel.isDownloadingPlatformsDriver, resultSelector: { (waitForRefreshPlatforms, isDownloadingPlatforms) -> Bool in
            return waitForRefreshPlatforms && isDownloadingPlatforms
        }).drive(loadingView.isActiveRelay).disposed(by: disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.refreshPlatformsIfNeed()
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

        case .originalReleaseDateFrom, .originalReleaseDateTo:
            pickOriginalReleaseDate(forFilter: filter, refreshCellFunc: refreshCellFunc)

        case .platforms:
            refreshPlatforms(showPickerForFilter: filter, refreshCellFunc: refreshCellFunc)

        default:
            return
        }
    }
}

 // MARK: - Filters pickers
extension GamesFiltersViewController {
    // MARK: Pick sorting option
    private func pickSortingOption(forFilter filter: GamesFilterModel, refreshCellFunc: @escaping () -> Void) {
        let viewLoadedAction = KODialogActionModel(title: filter.filter.localizable, action: { [weak self] (dialogViewController) in
            guard let optionsPickerViewController = dialogViewController as? KOOptionsPickerViewController else {
                fatalError("cast failed KOOptionsPickerViewController")
            }
            self?.initializeSortingOptionsPickerViewController(optionsPickerViewController, forFilter: filter, refreshCellFunc: refreshCellFunc)
        })
        _ = presentOptionsPicker(withOptions: [viewModel.availableSortingOptionsDisplayValues], viewLoadedAction: viewLoadedAction)
    }
    
    private func initializeSortingOptionsPickerViewController(_ optionsPickerViewController: KOOptionsPickerViewController, forFilter filter: GamesFilterModel, refreshCellFunc: @escaping () -> Void) {
        let currentSelectedSortingOptionIndex = viewModel.availableSortingOptions.firstIndex(where: { $0.value == filter.value }) ?? 0
    
        optionsPickerViewController.optionsPicker.selectRow(currentSelectedSortingOptionIndex, inComponent: 0, animated: false)
        optionsPickerViewController.rightBarButtonAction = KODialogActionModel.dismissAction(withTitle: "games_filters_picker_done_button".localized, action: { [weak self](optionsPicker: KOOptionsPickerViewController) in
            self?.pickSortingOption(fromOptionsPickerViewController: optionsPicker, forFilter: filter, refreshCellFunc: refreshCellFunc)
        })
        optionsPickerViewController.leftBarButtonAction = KODialogActionModel.dismissAction(withTitle: "games_filters_picker_cancel_button".localized)
    }
    
    private func pickSortingOption(fromOptionsPickerViewController optionsPickerViewController: KOOptionsPickerViewController, forFilter filter: GamesFilterModel, refreshCellFunc: @escaping () -> Void) {
        let selectedSortingOptionIndex = optionsPickerViewController.optionsPicker.selectedRow(inComponent: 0)
        let selectedSortingOption = viewModel.availableSortingOptions[selectedSortingOptionIndex]
        filter.value = selectedSortingOption.value
        filter.displayValue = selectedSortingOption.displayValue
        refreshCellFunc()
    }
    
    // MARK: Pick original release date
    private func pickOriginalReleaseDate(forFilter filter: GamesFilterModel, refreshCellFunc: @escaping () -> Void) {
        _ = presentDatePicker(viewLoadedAction: KODialogActionModel(title: filter.filter.localizable, action: { [weak self] (dialogViewController) in
            guard let datePickerViewController = dialogViewController as? KODatePickerViewController else {
                fatalError("cast failed KODatePickerViewController")
            }
            self?.initializeOriginalReleaseDatePickerViewController(datePickerViewController, forFilter: filter, refreshCellFunc: refreshCellFunc)
        }))
    }
    
    private func initializeOriginalReleaseDatePickerViewController(_ datePickerViewController: KODatePickerViewController, forFilter filter: GamesFilterModel, refreshCellFunc: @escaping () -> Void) {
        if let selectedDate = Utils.shared.filterDate(forValue: filter.value) {
            datePickerViewController.datePicker.date = selectedDate
        }
        datePickerViewController.datePicker.datePickerMode = .date
        datePickerViewController.rightBarButtonAction = KODialogActionModel.dismissAction(withTitle: "games_filters_picker_done_button".localized, action: { [weak self] (datePicker: KODatePickerViewController) in
            self?.pickOriginalReleaseDate(fromDatePickerViewController: datePicker, forFilter: filter, refreshCellFunc: refreshCellFunc)
        })
        datePickerViewController.leftBarButtonAction = KODialogActionModel.dismissAction(withTitle: "games_filters_picker_cancel_button".localized)
    }
    
    private func pickOriginalReleaseDate(fromDatePickerViewController datePickerViewController: KODatePickerViewController, forFilter filter: GamesFilterModel, refreshCellFunc: @escaping () -> Void) {
        filter.value = Utils.shared.filterDateValue(forDate: datePickerViewController.datePicker.date)
        viewModel.refreshDisplayValue(forFilter: filter)
        refreshCellFunc()
    }
    
    // MARK: Pick platforms
    private func refreshPlatforms(showPickerForFilter filter: GamesFilterModel, refreshCellFunc: @escaping () -> Void) {
        refreshPlatformsDisposeBag = DisposeBag()
        waitForRefreshPlatformsRelay.accept(true)
        
        viewModel.refreshPlatformsIfNeedObservable
            .catchError({ [weak self](error) -> Observable<Void> in
                self?.showError(message: error.localizedDescription)
                return Observable<Void>.just(())
            })
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else {
                    return
                }
                let isAvailable = self.viewModel.platforms.count > 0
                self.refreshPlatformsCompleted(isAvailable: isAvailable, showPickerForFilter: filter, refreshCellFunc: refreshCellFunc)
            }).disposed(by: refreshPlatformsDisposeBag)
    }
    
    private func refreshPlatformsCompleted(isAvailable: Bool, showPickerForFilter filter: GamesFilterModel, refreshCellFunc: @escaping () -> Void) {
        waitForRefreshPlatformsRelay.accept(false)
        guard isAvailable else {
            return
        }
        pickPlatforms(forFilter: filter, refreshCellFunc: refreshCellFunc)
    }
    
    private func pickPlatforms(forFilter filter: GamesFilterModel, refreshCellFunc: @escaping () -> Void) {
        _ = presentItemsTablePicker(viewLoadedAction: KODialogActionModel(title: filter.filter.localizable + "\n\(String(format: "games_filters_max_platforms".localized, self.platformsSelectedLimit))", action: { [weak self](dialogViewController) in
            guard let itemsTablePickerViewController = dialogViewController as? KOItemsTablePickerViewController else {
                fatalError("cast failed KOItemsTablePickerViewController")
            }
            self?.initializePlatformsPicker(itemsTablePickerViewController, forFilter: filter, refreshCellFunc: refreshCellFunc)
        }))
    }

    private func initializePlatformsPicker(_ itemsTablePicker: KOItemsTablePickerViewController, forFilter filter: GamesFilterModel, refreshCellFunc: @escaping () -> Void) {
        itemsTablePicker.mainView.contentHeight = 260
        itemsTablePicker.itemsTable.allowsMultipleSelection = true
        itemsTablePicker.itemsTable.separatorStyle = .none
        itemsTablePicker.itemsTable.rowHeight = PlatformViewCell.prefferedListHeight
        itemsTablePicker.itemsTable.register(UINib(nibName: "PlatformViewCell", bundle: nil), forCellReuseIdentifier: platformCellReuseIdentifier)
        itemsTablePicker.rightBarButtonAction = KODialogActionModel.dismissAction(withTitle: "games_filters_picker_done_button".localized, action: {[weak self](itemsTablePicker: KOItemsTablePickerViewController) in
            self?.viewModel.selectPlatforms(atIndexes: itemsTablePicker.itemsTable.indexPathsForSelectedRows, forFilter: filter)
            refreshCellFunc()
        })
        itemsTablePicker.leftBarButtonAction = KODialogActionModel.dismissAction(withTitle: "games_filters_picker_cancel_button".localized)

        bindPlatformsData(toItemsTablePicker: itemsTablePicker)
        bindPlatformsItemsSelected(fromItemsTablePicker: itemsTablePicker)
        setSelectedPlatforms(forItemsTablePicker: itemsTablePicker, filter: filter)
    }
    
    private func bindPlatformsData(toItemsTablePicker itemsTablePicker: KOItemsTablePickerViewController) {
        viewModel.platformsDriver.drive(itemsTablePicker.itemsTable.rx.items(cellIdentifier: self.platformCellReuseIdentifier)) { _, model, cell in
            (cell as? PlatformViewCell)?.platform = model
            }
            .disposed(by: refreshPlatformsDisposeBag)
    }
    
    private func bindPlatformsItemsSelected(fromItemsTablePicker itemsTablePicker: KOItemsTablePickerViewController) {
        //checks if user select more than count limit, simply will deselect platform above the limit
        itemsTablePicker.itemsTable.rx.itemSelected.asDriver().drive(onNext: { [weak self] indexPath in
            guard let self = self, itemsTablePicker.itemsTable.indexPathsForSelectedRows?.count ?? 0 > self.platformsSelectedLimit else {
                return
            }
            itemsTablePicker.itemsTable.deselectRow(at: indexPath, animated: true)
        }).disposed(by: refreshPlatformsDisposeBag)
    }
    
    private func setSelectedPlatforms(forItemsTablePicker itemsTablePicker: KOItemsTablePickerViewController, filter: GamesFilterModel) {
        guard let selectedIndexes = viewModel.selectedIndexes(forPlatformsFilter: filter) else {
            return
        }
        for selectedIndex in selectedIndexes {
            itemsTablePicker.itemsTable.selectRow(at: selectedIndex, animated: false, scrollPosition: .none)
        }
    }
}
