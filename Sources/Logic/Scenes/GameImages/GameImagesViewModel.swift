//
//  GameImagesViewModel.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation
import RxSwift
import RxCocoa

final class GameImagesViewModel: BaseViewModel {
    private let imagesRelay: BehaviorRelay<[ImageModel]>
    
    init(appCoordinator: AppCoordinatorProtocol, images: [ImageModel]) {
        imagesRelay = BehaviorRelay<[ImageModel]>(value: images)
        super.init(appCoordinator: appCoordinator)
    }
}

// MARK: - GameImagesViewModelProtocol
extension GameImagesViewModel: GameImagesViewModelProtocol {
    var imagesObservable: Observable<[ImageModel]> {
        return imagesRelay.asObservable()
    }
    
    func getImage(forIndexPath indexPath: IndexPath) -> ImageModel? {
        guard indexPath.row >= 0 && imagesRelay.value.count > indexPath.row else {
            return nil
        }
        return imagesRelay.value[indexPath.row]
    }
    
    func goToImageViewer(forImage image: ImageModel, navigationController: UINavigationController?) {
        _ = appCoordinator?.transition(.push(onNavigationController: navigationController), scene: ImageViewerSceneBuilder(image: image))
    }
}
