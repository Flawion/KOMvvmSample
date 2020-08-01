//
//  XCTestCase+Extension.swift
//  KOMvvmSampleLogicTests
//
//  Created by Kuba Ostrowski on 01/08/2020.
//

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
