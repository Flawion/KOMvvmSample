//
//  ServiceLocator.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation

protocol ServiceBuilderProtocol {
    var type: ServiceTypes { get }

    func createService(withServiceLocator serviceLocator: ServiceLocator) -> Any
}

enum ServiceTypes {
    case giantBombApiClient
    case dataStore
    case platforms
}

final class ServiceLocator {
    private var builderForServices: [ServiceTypes: Any] = [:]
    private var services: [ServiceTypes: Any?] = [:]

    func register(withBuilder builder: ServiceBuilderProtocol) {
        builderForServices[builder.type] = builder
        services[builder.type] = nil
    }

    func get<ReturnType>(type: ServiceTypes) -> ReturnType? {
        guard services[type] == nil else {
            return services[type] as? ReturnType
        }

        //lazy loading
        return tryToCreateAndReturnService(withType: type) as? ReturnType

    }

    private func tryToCreateAndReturnService(withType type: ServiceTypes) -> Any? {
        guard let builder = builderForServices[type] as? ServiceBuilderProtocol else {
            return nil
        }
        let newService = builder.createService(withServiceLocator: self)
        services[type] = newService
        builderForServices[type] = nil
        return newService
    }
}
