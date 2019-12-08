//
//  BaseViewController.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit
import RxSwift

class BaseViewController: UIViewController {
    // MARK: Variables
    let disposeBag: DisposeBag = DisposeBag()
    
    //additional controls
    lazy var loadingView: BaseStateView = {
        return initializeLoadingView()
    }()
    
    lazy var emptyView: BaseStateView = {
        return initializeEmptyView()
    }()
    
    lazy var errorView: BaseStateView = {
        return initializeErrorView()
    }()

    // MARK: Class functions
   override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        resizeBarTitleView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async { [weak self] in
            self?.resizeBarTitleView()
        }
    }

    private func resizeBarTitleView() {
        (navigationItem.titleView)?.sizeToFit()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.Theme.viewControllerBackground
    }

    // MARK: Navigation bar functions
    func prepareNavigationBar(withTitle title: String) {
        if navigationController?.viewControllers.count ?? 0 > 1 {
            addBarBackButton()
        }
        if !title.isEmpty {
            createBarTitleView(withTitle: title)
        }
    }

    private func addBarBackButton() {
        navigationItem.setLeftBarButton(UIBarButtonItem(image: UIImage(named: "backArrow")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(barBackButtonClicked)), animated: false)
    }
    
    @objc func barBackButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    private func createBarTitleView(withTitle title: String) {
        let barTitleLabel = createBarTitleLabel(withTitle: title)
        navigationItem.titleView = barTitleLabel
        resizeBarTitleView()
    }

    private func createBarTitleLabel(withTitle title: String) -> UILabel {
        let barTitleLabel = BaseLabel()
        barTitleLabel.textAlignment = .center
        barTitleLabel.font = UIFont.Theme.barTitleLabel
        barTitleLabel.numberOfLines = 2
        barTitleLabel.minimumScaleFactor = 0.5
        barTitleLabel.adjustsFontSizeToFitWidth = true
        barTitleLabel.lineBreakMode = .byWordWrapping
        barTitleLabel.text = title
        return barTitleLabel
    }

    // MARK: Initializing data state views functions, can be override to match to the specific layout
    func initializeLoadingView() -> BaseStateView {
        let loadingView = LoadingView()
        _ = view.addSafeAutoLayoutSubview(loadingView)
        return loadingView
    }
    
    func initializeEmptyView() -> BaseStateView {
        let emptyView = EmptyView()
        _ = view.addSafeAutoLayoutSubview(emptyView)
        return emptyView
    }
    
    func initializeErrorView() -> BaseStateView {
        let errorView = ErrorView()
        _ = view.addSafeAutoLayoutSubview(errorView)
        return errorView
    }
    
    func bindActions(toViewModel viewModel: BaseViewModel) {
        bindDataStateDrivers(toViewModel: viewModel)
        bindRaiseErrorDriver(toViewModel: viewModel)
    }

    private func bindDataStateDrivers(toViewModel viewModel: BaseViewModel) {
        viewModel.isDataStateLoadingDriver.drive(loadingView.isActiveVar).disposed(by: disposeBag)
        viewModel.isDataStateEmptyDriver.drive(emptyView.isActiveVar).disposed(by: disposeBag)
        viewModel.isDataStateErrorDriver.drive(errorView.isActiveVar).disposed(by: disposeBag)
    }

    private func bindRaiseErrorDriver(toViewModel viewModel: BaseViewModel) {
        viewModel.raiseErrorDriver.drive(onNext: { [weak self] error in
            guard let self = self else {
                return
            }
            self.showError(message: error.localizedDescription)
        }).disposed(by: disposeBag)
    }
}
