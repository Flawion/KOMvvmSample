//
//  XCTestCase+Extension.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import XCTest

extension XCTestCase {
    
    func resource(mockName: MockSettings.FileNames, extension: String) -> Data? {
        return resource(name: mockName.rawValue, extension: `extension`)
    }
    
    func resource(name: String, extension: String) -> Data? {
        guard let resourceUrl = Bundle(for: FiltersUtilsTests.self).url(forResource: name, withExtension: `extension`), let data = try? Data(contentsOf: resourceUrl) else {
            return nil
        }
        return data
    }
    
    func wait(timeout: TimeInterval) {
        let expection = expectation(description: "wait expection")
        DispatchQueue.main.asyncAfter(deadline: .now() + timeout) {
            expection.fulfill()
        }
        waitForExpectations(timeout: timeout + 0.1, handler: nil)
    }
}
