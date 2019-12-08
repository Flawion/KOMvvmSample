//
//  ServiceLocator.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

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
