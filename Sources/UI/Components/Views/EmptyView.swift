//
//  EmptyView.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation

final class EmptyView: BaseStateView {

    override func createView() {
        let emptyLabel = BaseLabel()
        emptyLabel.textAlignment = .center
        emptyLabel.text = "empty_title".localized
        _ = addAutoLayoutSubview(emptyLabel, settings: AddAutoLayoutSubviewSettings(insets: UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)))
    }

}
