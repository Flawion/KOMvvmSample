//
//  BaseViewController+Messages.swift
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

struct MessageAction {
    var id: Int
    var title: String

    ///Is it deafault action
    var isPrefered: Bool = false

    init(id: Int, title: String, isPrefered: Bool = false) {
        self.id = id
        self.title = title
        self.isPrefered = isPrefered
    }
}

final class DisposableAlertController: UIAlertController {
    let disposeBag = DisposeBag()
}

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
        message.observable.subscribe().disposed(by: disposeBag ?? message.alertController.disposeBag)
    }

    func showMessage(title: String? = nil, message: String?, cancelBttAction: MessageAction? = nil, destructiveBttAction: MessageAction? = nil, otherBttsActions: [MessageAction]? = nil, popoverView: UIView? = nil, popoverRect: CGRect? = nil, popoverBarBtt: UIBarButtonItem? = nil) -> (observable: Observable<Int>, alertController: DisposableAlertController) {

        let isPopoverPresentation = self.isPopoverPresentation(popoverView: popoverView, popoverRect: popoverRect, popoverBarBtt: popoverBarBtt)
        let alertController = DisposableAlertController(title: title, message: message, preferredStyle: isPopoverPresentation ? .actionSheet : .alert)

        let observable = Observable<Int>.create({ [weak self] observer in
            guard let self = self else {
                observer.onError(ApplicationErrors.selfNotExists)
                return Disposables.create()
            }

            self.fillAlertController(alertController, observer: observer, cancelBttAction: cancelBttAction, destructiveBttAction: destructiveBttAction, otherBttsActions: otherBttsActions)
            self.presentAlertController(alertController, popoverView: popoverView, popoverRect: popoverRect, popoverBarBtt: popoverBarBtt)

            return Disposables.create {
                alertController.dismiss(animated: false, completion: nil)
            }
        }).observeOn(MainScheduler.instance)
        return (observable, alertController)
    }

    private func isPopoverPresentation(popoverView: UIView? = nil, popoverRect: CGRect? = nil, popoverBarBtt: UIBarButtonItem? = nil) -> Bool {
        return (popoverView != nil && popoverRect != nil) || popoverBarBtt != nil
    }

    private func fillAlertController(_ alertController: UIAlertController, observer: AnyObserver<Int>, cancelBttAction: MessageAction? = nil, destructiveBttAction: MessageAction? = nil, otherBttsActions: [MessageAction]? = nil) {
        let cancelTempBtt = self.createDefaultCanceMesasgeActionIfThereAreNoButtons(cancelBttAction: cancelBttAction, destructiveBttAction: destructiveBttAction, otherBttsActions: otherBttsActions)
        self.addMessageActionIfNotNull(cancelTempBtt, withAlertStyle: .cancel, toAlertController: alertController, observer: observer)
        self.addMessageActionIfNotNull(destructiveBttAction, withAlertStyle: .destructive, toAlertController: alertController, observer: observer)
        self.addOtherButtonsIfNotNull(otherBttsActions: otherBttsActions, toAlertController: alertController, observer: observer)
    }

    private func createDefaultCanceMesasgeActionIfThereAreNoButtons(cancelBttAction: MessageAction? = nil, destructiveBttAction: MessageAction? = nil, otherBttsActions: [MessageAction]? = nil) -> MessageAction? {
        guard cancelBttAction == nil && destructiveBttAction == nil && otherBttsActions == nil else {
            return cancelBttAction
        }
        return MessageAction(id: 0, title: self.defaultMessageButtonTitle)
    }

    private func addMessageActionIfNotNull(_ messageAction: MessageAction?, withAlertStyle alertStyle: UIAlertAction.Style, toAlertController alertController: UIAlertController, observer: AnyObserver<Int>) {
        guard let messageAction = messageAction else {
            return
        }
        addMessageAction(messageAction, withAlertStyle: alertStyle, toAlertController: alertController, observer: observer)
    }

    private func addMessageAction(_ messageAction: MessageAction, withAlertStyle alertStyle: UIAlertAction.Style, toAlertController alertController: UIAlertController, observer: AnyObserver<Int>) {
        let alertAction = UIAlertAction(title: messageAction.title, style: alertStyle, handler: { _ in
            observer.onNext(messageAction.id)
        })
        alertController.addAction(alertAction)
        tryToSetPreferredAlertAction(alertAction, messageAction: messageAction, toAlertController: alertController)
    }

    private func tryToSetPreferredAlertAction(_ action: UIAlertAction, messageAction: MessageAction, toAlertController alertController: UIAlertController) {
        guard messageAction.isPrefered && action.style == .default else {
            return
        }
        alertController.preferredAction = action
    }

    private func addOtherButtonsIfNotNull(otherBttsActions: [MessageAction]? = nil, toAlertController alertController: UIAlertController, observer: AnyObserver<Int>) {
        guard let otherButtons = otherBttsActions else {
            return
        }
        for otherButton in otherButtons {
            self.addMessageAction(otherButton, withAlertStyle: .default, toAlertController: alertController, observer: observer)
        }
    }

    private func presentAlertController(_ alertController: DisposableAlertController, popoverView: UIView? = nil, popoverRect: CGRect? = nil, popoverBarBtt: UIBarButtonItem? = nil) {
        setPopoverSettings(forAlertController: alertController, popoverView: popoverView, popoverRect: popoverRect, popoverBarBtt: popoverBarBtt)
        present(alertController, animated: true, completion: nil)
    }

    private func setPopoverSettings(forAlertController alertController: DisposableAlertController, popoverView: UIView? = nil, popoverRect: CGRect? = nil, popoverBarBtt: UIBarButtonItem? = nil) {
        let isPopoverPresentation = self.isPopoverPresentation(popoverView: popoverView, popoverRect: popoverRect, popoverBarBtt: popoverBarBtt)
        guard isPopoverPresentation, let popoverPresentation = alertController.popoverPresentationController else {
            return
        }
        popoverPresentation.barButtonItem = popoverBarBtt
        if let popoverRect = popoverRect {
            popoverPresentation.sourceRect = popoverRect
        }
        popoverPresentation.sourceView = popoverView
    }
}
