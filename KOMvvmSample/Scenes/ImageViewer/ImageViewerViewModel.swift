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
    private let imageVar: BehaviorRelay<ImageModel>
    
    var image: ImageModel {
        return imageVar.value
    }
    
    init(appCoordinator: AppCoordinatorProtocol, image: ImageModel) {
        imageVar = BehaviorRelay<ImageModel>(value: image)
        
        super.init(appCoordinator: appCoordinator)
    }
}
