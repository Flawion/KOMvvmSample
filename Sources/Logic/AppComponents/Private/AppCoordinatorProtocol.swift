//
//  AppCoordinatorProtocol.swift
//  KOMvvmSampleLogic
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation

protocol AppCoordinatorProtocol: NSObjectProtocol {
    var blockAllUserInteraction: Bool { get set }
    
    func initializeScene()
    func openLink(_ url: URL)
    func transition(_ transtion: BaseSceneTransition, scene: SceneBuilderProtocol) -> Any?
    func transition(_ transtion: BaseSceneTransition, scenes: [SceneBuilderProtocol]) -> Any?
}

protocol AppCoordinatorResouresProtocol: NSObjectProtocol {
    func getService<ReturnType>(type: ServiceTypes) -> ReturnType?
    func getSceneViewController(forViewModel viewModel: ViewModelProtocol, type: SceneTypes) -> ViewControllerProtocol?
}
