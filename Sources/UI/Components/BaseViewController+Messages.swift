//
//  BaseViewController+Messages.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit
import RxSwift
import KOMvvmSampleLogic

struct MessageAction {
    let id: Int
    let title: String
    let isDefaultAction: Bool

    init(id: Int, title: String, isDefaultAction: Bool = false) {
        self.id = id
        self.title = title
        self.isDefaultAction = isDefaultAction
    }
}

struct MessageActions {
    let cancelAction: MessageAction?
    let destructiveAction: MessageAction?
    let otherActions: [MessageAction]?

    var isEmpty: Bool {
        return cancelAction == nil && destructiveAction == nil && otherActions == nil
    }

    init(cancelAction: MessageAction? = nil, destructiveAction: MessageAction? = nil, otherActions: [MessageAction]? = nil) {
        self.cancelAction = cancelAction
        self.destructiveAction = destructiveAction
        self.otherActions = otherActions
    }
}

struct MessagePopoverSettings {
    let view: UIView?
    let rect: CGRect?
    let barButton: UIBarButtonItem?

    var isPopoverPresentation: Bool {
        return (view != nil && rect != nil) || barButton != nil
    }

    init(view: UIView? = nil, rect: CGRect? = nil, barButton: UIBarButtonItem? = nil) {
        self.view = view
        self.rect = rect
        self.barButton = barButton
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

    func showMessage(title: String? = nil, message: String?, actions: MessageActions? = nil, popoverSettings: MessagePopoverSettings? = nil) -> (observable: Observable<Int>, alertController: DisposableAlertController) {

        let isPopoverPresentation = popoverSettings?.isPopoverPresentation ?? false
        let alertController = DisposableAlertController(title: title, message: message, preferredStyle: isPopoverPresentation ? .actionSheet : .alert)

        let observable = Observable<Int>.create({ [weak self] observer in
            guard let self = self else {
                observer.onError(AppError(withCode: .commonSelfNotExists))
                return Disposables.create()
            }

            self.fillAlertController(alertController, observer: observer, actions: actions)
            self.presentAlertController(alertController, popoverSettings: popoverSettings)

            return Disposables.create {
                alertController.dismiss(animated: false, completion: nil)
            }
        }).observe(on: MainScheduler.instance)
        return (observable, alertController)
    }

    private func isPopoverPresentation(popoverView: UIView? = nil, popoverRect: CGRect? = nil, popoverBarBtt: UIBarButtonItem? = nil) -> Bool {
        return (popoverView != nil && popoverRect != nil) || popoverBarBtt != nil
    }

    private func fillAlertController(_ alertController: UIAlertController, observer: AnyObserver<Int>, actions: MessageActions? = nil) {
        let finalCancelAction = self.createDefaultCanceMesasgeActionIfNeed(actions: actions)
        self.addIfNotNull(messageAction: finalCancelAction, withAlertStyle: .cancel, toAlertController: alertController, observer: observer)
        self.addIfNotNull(messageAction: actions?.destructiveAction, withAlertStyle: .destructive, toAlertController: alertController, observer: observer)
        self.addIfNotNull(otherActions: actions?.otherActions, toAlertController: alertController, observer: observer)
    }

    private func createDefaultCanceMesasgeActionIfNeed(actions: MessageActions?) -> MessageAction? {
        if let actions = actions, !actions.isEmpty {
            return actions.cancelAction
        }
        return MessageAction(id: 0, title: self.defaultMessageButtonTitle)
    }

    private func addIfNotNull(messageAction: MessageAction?, withAlertStyle alertStyle: UIAlertAction.Style, toAlertController alertController: UIAlertController, observer: AnyObserver<Int>) {
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
        guard messageAction.isDefaultAction && action.style == .default else {
            return
        }
        alertController.preferredAction = action
    }

    private func addIfNotNull(otherActions: [MessageAction]? = nil, toAlertController alertController: UIAlertController, observer: AnyObserver<Int>) {
        guard let otherButtons = otherActions else {
            return
        }
        for otherButton in otherButtons {
            self.addMessageAction(otherButton, withAlertStyle: .default, toAlertController: alertController, observer: observer)
        }
    }

    private func presentAlertController(_ alertController: DisposableAlertController, popoverSettings: MessagePopoverSettings? = nil) {
        setPopoverSettings(forAlertController: alertController, popoverSettings: popoverSettings)
        present(alertController, animated: true, completion: nil)
    }

    private func setPopoverSettings(forAlertController alertController: DisposableAlertController, popoverSettings: MessagePopoverSettings? = nil) {
        guard let popoverSettings = popoverSettings, popoverSettings.isPopoverPresentation, let popoverPresentation = alertController.popoverPresentationController else {
            return
        }
        popoverPresentation.barButtonItem = popoverSettings.barButton
        if let popoverRect = popoverSettings.rect {
            popoverPresentation.sourceRect = popoverRect
        }
        popoverPresentation.sourceView = popoverSettings.view
    }
}
