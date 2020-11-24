//
//  AppCoordinatorProtocol.swift
//  KOMvvmSampleLogic
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation

public protocol AppCoordinatorProtocol: AnyObject {
    var isUserInteractionEnabled: Bool { get set }
    
    func initializeScene()
    func openLink(_ url: URL)
    func transition(_ transtion: BaseSceneTransition, toScene scene: SceneResolverProtocol) -> Any?
    func transition(_ transtion: BaseSceneTransition, toScenes scenes: [SceneResolverProtocol]) -> Any?
}
