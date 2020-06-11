//
//  Array+Extension.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation

extension Array {
    mutating func appendIfNotNull(_ newElement: Element?) {
        guard let element = newElement else {
            return
        }
        append(element)
    }

    mutating func appendIfNotNull(_ contentsOf: [Element?]) {
        for newElement in contentsOf {
            appendIfNotNull(newElement)
        }
    }
}
