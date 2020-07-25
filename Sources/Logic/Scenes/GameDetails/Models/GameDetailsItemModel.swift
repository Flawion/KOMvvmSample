//
//  GameDetailsItemModel.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation

public struct GameDetailsItemModel {
    public let item: GameDetailsItems
    public let contentSize: Int

    public var localizedName: String {
        if contentSize > 0 {
            return String(format: "%@ (%d)", item.rawValue.localized, contentSize)
        }
        return item.rawValue.localized
    }

    init(item: GameDetailsItems, contentSize: Int) {
        self.item = item
        self.contentSize = contentSize
    }
}
