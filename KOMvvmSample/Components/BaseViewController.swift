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
        return createLoadingView()
    }()
    
    lazy var emptyView: BaseStateView = {
        return createEmptyView()
    }()
    
    lazy var errorView: BaseStateView = {
        return createErrorView()
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

    private func createBarTitleView(withTitle title: String) {
        let titleLabel = BaseLabel()
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.Theme.barTitleLabel
        titleLabel.numberOfLines = 2
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.text = title

        navigationItem.titleView = titleLabel
        titleLabel.sizeToFit()
    }

    private func addBarBackButton() {
        navigationItem.setLeftBarButton(UIBarButtonItem(image: UIImage(named: "backArrow")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(barBackButtonClicked)), animated: false)
    }

    @objc func barBackButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: Creating functions, can be override to match to the specific layout
    func createLoadingView() -> BaseStateView {
        let loadingView = LoadingView()
        _ = view.addSafeAutoLayoutSubview(loadingView)
        return loadingView
    }
    
    func createEmptyView() -> BaseStateView {
        let emptyView = EmptyView()
        _ = view.addSafeAutoLayoutSubview(emptyView)
        return emptyView
    }
    
    func createErrorView() -> BaseStateView {
        let errorView = ErrorView()
        _ = view.addSafeAutoLayoutSubview(errorView)
        return errorView
    }
    
    func bindActions(toViewModel viewModel: BaseViewModel) {
        viewModel.isDataLoadingDriver.drive(loadingView.isActiveVar).disposed(by: disposeBag)
        viewModel.isDataEmptyDriver.drive(emptyView.isActiveVar).disposed(by: disposeBag)
        viewModel.isDataErrorDriver.drive(errorView.isActiveVar).disposed(by: disposeBag)
        
        viewModel.raiseErrorDriver.drive(onNext: { [weak self] error in
            guard let self = self else {
                return
            }
            self.showError(message: error.localizedDescription)
        }).disposed(by: disposeBag)
    }
}

// MARK: - Messages extension
extension BaseViewController {
    
    // MARK: Variables
    var defaultErrorTitle: String {
        return "msg_error_title".localized
    }
    
    var defaultMessageButtonTitle: String {
        return "msg_ok".localized
    }
    
    // MARK: Functions
    func showError(message: String?, withDisposeBag disposeBag: DisposeBag? = nil) {
        let message = showMessage(title: defaultErrorTitle, message: message)
        if let disposeBag = disposeBag {
            message.observable.subscribe().disposed(by: disposeBag)
        } else {
            message.observable.subscribe().disposed(by: message.alertController.disposeBag)
        }
    }
    
    func showMessage(title: String? = nil, message: String?, cancelBttAction: MessageAction? = nil, destructiveBttAction: MessageAction? = nil, otherBttsActions: [MessageAction]? = nil, popoverView: UIView? = nil, popoverRect: CGRect? = nil, popoverBarBtt: UIBarButtonItem? = nil) -> (observable: Observable<Int>, alertController: DisposableAlertController) {
        let isPopover = (popoverView != nil && popoverRect != nil) || popoverBarBtt != nil
        
        let alertController = DisposableAlertController(title: title, message: message, preferredStyle: isPopover ? .actionSheet : .alert)
        let observable = Observable<Int>.create({ [weak self] observable in
            guard let self = self else {
                observable.onError(ApplicationErrors.selfNotExists)
                return Disposables.create()
            }
            //creates alert controller
            var cancelTempBtt = cancelBttAction
            
            //adds default button
            if cancelBttAction == nil && destructiveBttAction == nil && otherBttsActions == nil {
                cancelTempBtt = MessageAction(id: 0, title: self.defaultMessageButtonTitle)
            }
            
            //adds cancel btt
            if let cancelBtt = cancelTempBtt {
                let cancelAction = UIAlertAction(title: cancelBtt.title, style: .cancel, handler: { _ in
                    observable.onNext(cancelBtt.id)
                })
                alertController.addAction(cancelAction)
            }
            
            //adds destructive btt
            if let destructiveBtt = destructiveBttAction {
                let destructiveAction = UIAlertAction(title: destructiveBtt.title, style: .destructive, handler: { _ in
                    observable.onNext(destructiveBtt.id)
                })
                alertController.addAction(destructiveAction)
            }
            
            //adds other buttons
            if let otherButtons = otherBttsActions {
                for otherButton in otherButtons {
                    let otherButtonAction = UIAlertAction(title: otherButton.title, style: .default, handler: { _ in
                        observable.onNext(otherButton.id)
                    })
                    alertController.addAction(otherButtonAction)
                    //check is need to be preffered
                    if otherButton.isPrefered {
                        alertController.preferredAction = otherButtonAction
                    }
                }
            }
            
            //presents message
            if isPopover, let popoverPresentation = alertController.popoverPresentationController {
                popoverPresentation.barButtonItem = popoverBarBtt
                if let popoverRect = popoverRect {
                    popoverPresentation.sourceRect = popoverRect
                }
                popoverPresentation.sourceView = popoverView
            }
            self.present(alertController, animated: true, completion: nil)

            return Disposables.create {
                alertController.dismiss(animated: false, completion: nil)
            }
        }).observeOn(MainScheduler.instance)
        return (observable, alertController)
    }
}

final class DisposableAlertController: UIAlertController {
    let disposeBag = DisposeBag()
}
