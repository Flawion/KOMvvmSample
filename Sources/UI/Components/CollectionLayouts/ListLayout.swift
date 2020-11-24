//
//  ListLayout.swift
//  KOMvvmSample
//
//  Copyright (c) 2020 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation

final class ListLayout: CollectionAutoResizeFlowLayout {
    private let preferredCellHeight: CGFloat
    
    init(preferredCellHeight: CGFloat) {
        self.preferredCellHeight = preferredCellHeight
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func resizeLayout(toSize size: CGSize) {
        sectionInset = UIEdgeInsets.zero
        minimumLineSpacing = 0
        itemSize = CGSize(width: size.width, height: preferredCellHeight)
    }
}
