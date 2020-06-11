//
//  GamesFiltersViewControllerInterface.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation
import RxSwift

protocol GamesFiltersViewControllerProtocol: ViewControllerProtocol {
    var viewModel: GamesFiltersViewModelProtocol { get }
    var disposeBag: DisposeBag { get }

    func goBack() 
    func pickNewValue(forFilter filter: GamesFilterModel, refreshCellFunc: @escaping () -> Void)
}
