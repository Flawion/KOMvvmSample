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

class ServiceBuilder<Type: Any> {
    func createService<Type: Any>(withServiceLocator serviceLocator: ServiceLocator) -> Type {
        fatalError("createService has not been implemented")
    }
}

final class ServiceLocator {
    private var builderForServices: [String: Any] = [:]
    private var services: [String: Any?] = [:]

    func register<Type: Any>(withBuilder builder: ServiceBuilder<Type>) {
        let typeName = self.typeName(Type.self)
        builderForServices[typeName] = builder
        services[typeName] = nil
    }

    func get<Type: Any>() -> Type? {
        let typeName = self.typeName(Type.self)
        guard services[typeName] == nil else {
            return services[typeName] as? Type
        }

        //lazy loading
        return tryToCreateAndReturnService(withTypeName: typeName)

    }

    private func typeName(_ type: Any.Type) -> String {
        let name = "\(type)"
        return name
    }

    private func tryToCreateAndReturnService<Type: Any>(withTypeName typeName: String) -> Type? {
        guard let builder = builderForServices[typeName] as? ServiceBuilder<Type> else {
            return nil
        }
        let newService: Type = builder.createService(withServiceLocator: self)
        services[typeName] = newService
        builderForServices[typeName] = nil
        return newService
    }
}
