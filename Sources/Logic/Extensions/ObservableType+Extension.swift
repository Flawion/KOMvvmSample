//
//  ObservableType+Extension.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation
import RxCocoa
import RxSwift

extension ObservableType {
    
    func doOnce(_ handler: @escaping (Self.Element?, Error?) -> Void) -> RxSwift.Observable<Self.Element> {
        let invokeOnce = InvokeOnceParamOrError({ (object, error) in
            handler(object, error)
        })
        return self.do(onNext: { (data) in
            invokeOnce.invoke(param: data, error: nil)
        }, onError: { (error) in
            invokeOnce.invoke(param: nil, error: error)
        }, onCompleted: {
            invokeOnce.invoke(param: nil, error: nil)
        },
           onDispose: {
            invokeOnce.invoke(param: nil, error: nil)
        })
    }
}

final class InvokeOnceParamOrError<T> {
    var invokeFunc: ((T?, Error?) -> Void)?

    init(_ invokeFunc: @escaping (T?, Error?) -> Void) {
        self.invokeFunc = invokeFunc
    }

    func invoke(param: T? = nil, error: Error? = nil) {
        let invokeFunc = self.invokeFunc
        self.invokeFunc = nil
        invokeFunc?(param, error)
    }
}
