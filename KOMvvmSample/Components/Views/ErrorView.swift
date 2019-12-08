//
//  ErrorView.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation
import RxSwift
import RxCocoa

final class ErrorView: BaseStateView {
    private weak var viewContainer: UIView!
    private weak var refreshButton: UIButton!
    private weak var titleLabel: BaseLabel!

    var refreshButtonClicked: ControlEvent<()> {
        return refreshButton.rx.controlEvent(.touchUpInside)
    }

    override func createView() {
        createViewContainer()
        createTitleLabel()
        createRefreshButton()
    }

    private func createViewContainer() {
        let viewContainer = UIView()
        viewContainer.translatesAutoresizingMaskIntoConstraints = false
        _ = addAutoLayoutSubview(viewContainer, settings: AddAutoLayoutSubviewSettings(toAddConstraints: [.left, .right], operations: [.left: .equalOrGreater, .right: .equalOrLess]))
        addConstraints([
            viewContainer.centerXAnchor.constraint(equalTo: centerXAnchor).withPriority(900),
            viewContainer.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        self.viewContainer = viewContainer
    }

    private func createTitleLabel() {
        let titleLabel = BaseLabel()
        titleLabel.textAlignment = .center
        titleLabel.text = "error_title".localized
        _ = viewContainer.addAutoLayoutSubview(titleLabel, toAddConstraints: [.left, .top, .right])
        self.titleLabel = titleLabel
    }

    private func createRefreshButton() {
        let refreshButton = ConfirmButton()
        refreshButton.setTitle("error_refresh_button_title".localized, for: .normal)
        _ = viewContainer.addAutoLayoutSubview(refreshButton, settings: createAddAutoLayoutSubviewSettingsForRefreshButton())
        self.refreshButton = refreshButton
    }

    private func createAddAutoLayoutSubviewSettingsForRefreshButton() -> AddAutoLayoutSubviewSettings {
        var addAutoLayoutSubviewSettings = AddAutoLayoutSubviewSettings()
        addAutoLayoutSubviewSettings.overrideAnchors = AnchorsContainer(top: titleLabel.bottomAnchor)
        addAutoLayoutSubviewSettings.insets = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0)
        return addAutoLayoutSubviewSettings
    }
}
