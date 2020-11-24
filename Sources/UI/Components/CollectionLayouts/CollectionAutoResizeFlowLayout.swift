//
//  CollectionAutoResizeFlowLayout.swift
//  KOMvvmSample
//
//  Copyright (c) 2020 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit

class CollectionAutoResizeFlowLayout: UICollectionViewFlowLayout {
    private var layoutResizedForSize: CGSize = .zero
    
    override func prepare() {
        super.prepare()
        resizeLayoutIfNeed()
    }
        
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        resizeLayoutIfNeed(toSize: newBounds.size)
        guard !super.shouldInvalidateLayout(forBoundsChange: newBounds) else {
            return true
        }
        return collectionView?.bounds.size != newBounds.size
    }
    
    private func resizeLayoutIfNeed() {
        guard let collectionViewSize = collectionView?.bounds.size else {
            return
        }
        resizeLayoutIfNeed(toSize: collectionViewSize)
    }
    
    private func resizeLayoutIfNeed(toSize size: CGSize) {
        guard layoutResizedForSize != size else {
            return
        }
        layoutResizedForSize = size
        resizeLayout(toSize: size)
    }
    
    func resizeLayout(toSize size: CGSize) {
        // to override
    }
}
