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
    private let imagesVar: BehaviorRelay<[ImageModel]>

    var imagesObser: Observable<[ImageModel]> {
        return imagesVar.asObservable()
    }

    init(images: [ImageModel]) {
        imagesVar = BehaviorRelay<[ImageModel]>(value: images)

        super.init()
    }
    
    func getImage(forIndexPath indexPath: IndexPath) -> ImageModel? {
        guard imagesVar.value.count > indexPath.row else {
            return nil
        }
        return imagesVar.value[indexPath.row]
    }
}
