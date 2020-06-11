//
//  LoadingView.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit

final class LoadingView: BaseStateView {
    private weak var viewContainer: UIView!
    private weak var activityIndicatorView: UIActivityIndicatorView!
    private weak var titleLabel: BaseLabel!
    
    override func createView() {
        createContainerView()
        createActivityIndicatorView()
        createTitleLabel()
    }

    private func createContainerView() {
        let viewContainer = UIView()
        _ = addAutoLayoutSubview(viewContainer, settings: AddAutoLayoutSubviewSettings(toAddConstraints: [.left, .right], operations: [.left: .equalOrGreater, .right: .equalOrLess]))
        addConstraints([
            viewContainer.centerXAnchor.constraint(equalTo: centerXAnchor).withPriority(900),
            viewContainer.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        self.viewContainer = viewContainer
    }

    private func createActivityIndicatorView() {
        let activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicatorView.color = UIColor.Theme.loadingActivityIndicator
        _ = viewContainer.addAutoLayoutSubview(activityIndicatorView, toAddConstraints: [.top, .left, .right])
        self.activityIndicatorView = activityIndicatorView
    }

    private func createTitleLabel() {
        let titleLabel = BaseLabel()
        titleLabel.textAlignment = .center
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        titleLabel.text = "loading_title".localized
        _ = viewContainer.addAutoLayoutSubview(titleLabel, settings: createAddAutoLayoutSubviewSettingsForTitleLabel())
        self.titleLabel = titleLabel
    }

    private func createAddAutoLayoutSubviewSettingsForTitleLabel() -> AddAutoLayoutSubviewSettings {
        var addAutoLayoutSubviewSettings = AddAutoLayoutSubviewSettings()
        addAutoLayoutSubviewSettings.overrideAnchors = AnchorsContainer(top: activityIndicatorView.bottomAnchor)
        addAutoLayoutSubviewSettings.insets = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0)
        return addAutoLayoutSubviewSettings
    }
    
    override func startActive() {
        super.startActive()
        activityIndicatorView.startAnimating()
    }
    
    override func stopActive() {
        super.stopActive()
        activityIndicatorView.stopAnimating()
    }
}
