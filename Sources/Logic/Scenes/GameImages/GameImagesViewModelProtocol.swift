//
//  GameImagesViewModelProtocol.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import RxSwift
import RxCocoa

protocol GameImagesViewModelProtocol: ViewModelProtocol {
    var imagesObservable: Observable<[ImageModel]> { get }
    
    func getImage(forIndexPath indexPath: IndexPath) -> ImageModel?
    func goToImageViewer(forImage image: ImageModel, navigationController: UINavigationController?)
}
