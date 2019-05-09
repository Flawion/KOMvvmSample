//
//  ErrorView.swift
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

import Foundation
import RxSwift
import RxCocoa

class ErrorView: BaseStateView {
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
        addSubview(viewContainer)
        addConstraints([
            viewContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            viewContainer.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        self.viewContainer = viewContainer
    }

    private func createTitleLabel() {
        let titleLabel = BaseLabel()
        titleLabel.text = "error_title".localized
        _ = viewContainer.addAutoLayoutSubview(titleLabel, toAddConstraints: [.left, .top, .right])
        self.titleLabel = titleLabel
    }

    private func createRefreshButton() {
        let refreshButton = ConfirmButton()
        refreshButton.setTitle("error_refresh_btt_title".localized, for: .normal)
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
