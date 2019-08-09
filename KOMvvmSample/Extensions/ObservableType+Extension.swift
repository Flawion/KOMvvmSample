//
//  ObservableType+Extension.swift
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
import RxCocoa
import RxSwift

extension ObservableType {
    //chain ends working on this method and continue after next onNext ;)
    func catchErrorContinueAfterOnNext(handler: @escaping (Error) throws -> Void) -> RxSwift.Observable<Self.Element> {
        return self.catchError { error in
            try handler(error)
            return Observable.error(error)
            }.retry()
    }

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

class InvokeOnceParamOrError<T> {
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
