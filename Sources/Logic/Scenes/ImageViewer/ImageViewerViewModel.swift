//
//  ImageViewerViewModel.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation
import RxSwift
import RxCocoa

final class ImageViewerViewModel: BaseViewModel {
    private let imageRelay: BehaviorRelay<ImageModel>
    
    init(appCoordinator: AppCoordinatorProtocol, image: ImageModel) {
        imageRelay = BehaviorRelay<ImageModel>(value: image)
        super.init(appCoordinator: appCoordinator)
    }
}

extension ImageViewerViewModel: ImageViewerViewModelProtocol {
    var image: ImageModel {
        return imageRelay.value
    }
    
    func change(dataActionState: DataActionStates) {
        self.dataActionState = dataActionState
    }
}
