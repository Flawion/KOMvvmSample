//
//  ImageViewerViewModelProtocol.swift
//  KOMvvmSample
//
//  Created by Kuba Ostrowski on 11/06/2020.
//

import Foundation

protocol ImageViewerViewModelProtocol: ViewModelProtocol {
    var image: ImageModel { get }
    
    func change(dataActionState: DataActionStates)
}
