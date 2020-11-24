//
//  ImageViewerViewControllerRegister.swift
//  KOMvvmSample
//
//  Copyright (c) 2020 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import KOMvvmSampleLogic
import KOInject

struct ImageViewerViewControllerRegister: ViewControllerRegisterProtocol {
    func register(register: KOIRegisterProtocol) {
        register.register(forType: ImageViewerViewControllerProtocol.self, scope: .separate) { (resolver, appCoordinator: AppCoordinatorProtocol, image: ImageModel) in
            guard let viewModel: ImageViewerViewModelProtocol = resolver.resolve(arg1: appCoordinator, arg2: image) else {
                fatalError(fatalErrorMessage)
            }
            return ImageViewerViewController(viewModel: viewModel)
        }
    }
}
