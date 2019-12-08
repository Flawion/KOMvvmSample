//
//  GameDetailsViewControllerProtocol.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation

protocol GameDetailsViewControllerProtocol: NSObjectProtocol {
    var viewModel: GameDetailsViewModel { get }

    func goToDetailsItem(_ detailsItem: GameDetailsItemModel)
    func resizeDetailsFooterView()
}
