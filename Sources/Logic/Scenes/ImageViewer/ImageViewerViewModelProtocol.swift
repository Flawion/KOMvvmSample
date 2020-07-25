//
//  ImageViewerViewModelProtocol.swift
//  KOMvvmSample
//
//  Created by Kuba Ostrowski on 11/06/2020.
//

import Foundation

public protocol ImageViewerViewModelProtocol: ViewModelProtocol {
    var image: ImageModel { get }
    
    func change(dataActionState: DataActionStates)
}
