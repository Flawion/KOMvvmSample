//
//  Utils+Devices.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation

enum DevicesScreenWidth: CGFloat {
    case small = 320
    case normal = 375
    case large = 414
}

extension Utils {
    var isSmallDevice: Bool {
        return UIScreen.main.bounds.width < DevicesScreenWidth.normal.rawValue
    }

    var isNormalDevice: Bool {
        return DevicesScreenWidth.normal.rawValue ..< DevicesScreenWidth.large.rawValue ~= UIScreen.main.bounds.width
    }

    var isLargeDevice: Bool {
        return UIScreen.main.bounds.width >= DevicesScreenWidth.large.rawValue
    }
}
