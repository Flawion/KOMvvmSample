//
//  LoadingView.swift
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
