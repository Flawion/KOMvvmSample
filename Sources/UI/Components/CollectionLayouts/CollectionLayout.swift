//
//  CollectionLayout.swift
//  KOMvvmSample
//
//  Copyright (c) 2020 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation

final class CollectionLayout: CollectionAutoResizeFlowLayout {
    private let preferredCellSize: CGSize
    
    init(preferredCellSize: CGSize) {
        self.preferredCellSize = preferredCellSize
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func resizeLayout(toSize size: CGSize) {
        let itemMinWidth = preferredCellSize.width
        let itemMargin: CGFloat = 4
        let inset: CGFloat = 4
        let parentWidth = size.width - inset * 2
        let divider = max(2.0, parentWidth / (itemMinWidth + (itemMargin * 0.5)))
        let column = floor(divider)
        let allMargins = itemMargin * (column - 1)
        let marginedParentWidth = parentWidth - allMargins
        let itemSize = floor(marginedParentWidth / column)
        let itemAdditionalHeight = preferredCellSize.height - preferredCellSize.width
        
        minimumInteritemSpacing = itemMargin
        minimumLineSpacing = itemMargin
        self.itemSize = CGSize(width: itemSize, height: itemSize + itemAdditionalHeight)
        sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
}
