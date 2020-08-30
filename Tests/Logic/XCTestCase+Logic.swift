//
//  XCTestCase+Extension.swift
//  KOMvvmSampleLogicTests
//
//  Copyright (c) 2020 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import XCTest

@testable import KOMvvmSampleLogic

extension XCTestCase {
    func jsonModel<Type: Codable>(mockName: MockSettings.FileNames) -> Type? {
        guard let resourceData = resource(mockName: mockName, extension: "json"), let jsonModel: Type? = try? ApiDataToJsonMapper().mapTo(data: resourceData) else {
            return nil
        }
        return jsonModel
    }

}
