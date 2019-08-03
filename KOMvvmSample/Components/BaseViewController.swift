//
//  BaseViewController.swift
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
        barTitleLabel.sizeToFit()
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
