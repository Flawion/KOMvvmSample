//
//  GamesViewControllerProtocol.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation

protocol GamesViewControllerProtocol: NSObjectProtocol {
    var viewModel: GamesViewModel { get }

    func addBarListLayoutButton()
    func addBarCollectionLayoutButton()
    func goToGameDetail(_ game: GameModel)
}
