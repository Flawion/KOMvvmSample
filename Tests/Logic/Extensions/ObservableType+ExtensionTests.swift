//
//  ObservableTypeExtensionTests.swift
//  KOMvvmSampleLogicTests
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import XCTest
import RxSwift

@testable import KOMvvmSampleLogic

final class ObservableTypeExtensionTests: XCTestCase {
    
    private var publishSubject: PublishSubject<Int>!
    
    override func setUp() {
        publishSubject = PublishSubject<Int>()
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        publishSubject = nil
    }
    
    func testDoOnceOnNext() {
        let disposeBag = DisposeBag()
        var doCount: Int = 0
        var doResult: Int?
        var doError: NSError?
        publishSubject.asObserver().doOnce { (result, error) in
            doCount += 1
            doResult = result
            doError = error as NSError?
        }.subscribe().disposed(by: disposeBag)
        
        publishSubject.onNext(10)
        publishSubject.onNext(20)
        publishSubject.onError(NSError(domain: "test", code: 0, userInfo: nil))
        wait(timeout: 0.05)
        
        XCTAssertEqual(doCount, 1)
        XCTAssertEqual(doResult, 10)
        XCTAssertNil(doError)
    }
    
    func testDoOnceOnError() {
        let disposeBag = DisposeBag()
        var doCount: Int = 0
        var doResult: Int?
        var doError: NSError?
        let errorToPass = NSError(domain: "test", code: 0, userInfo: nil)
        publishSubject.asObserver().doOnce { (result, error) in
            doCount += 1
            doResult = result
            doError = error as NSError?
        }.subscribe().disposed(by: disposeBag)
        
        publishSubject.onError(errorToPass)
        publishSubject.onNext(10)
        publishSubject.onNext(20)
        wait(timeout: 0.05)
        
        XCTAssertEqual(doCount, 1)
        XCTAssertEqual(doError, errorToPass)
        XCTAssertNil(doResult)
    }
    
    func testDoOnceOnCompleted() {
        let disposeBag = DisposeBag()
        var doCount: Int = 0
        var doResult: Int?
        var doError: NSError?
        let errorToPass = NSError(domain: "test", code: 0, userInfo: nil)
        publishSubject.asObserver().doOnce { (result, error) in
            doCount += 1
            doResult = result
            doError = error as NSError?
        }.subscribe().disposed(by: disposeBag)
        
        publishSubject.onCompleted()
        publishSubject.onNext(10)
        publishSubject.onNext(20)
        publishSubject.onError(errorToPass)
        wait(timeout: 0.05)
        
        XCTAssertEqual(doCount, 1)
        XCTAssertNil(doError)
        XCTAssertNil(doResult)
    }
    
    func testDoOnceOnDispose() {
        var disposeBag: DisposeBag? = DisposeBag()
        var doCount: Int = 0
        var doResult: Int?
        var doError: NSError?
        let errorToPass = NSError(domain: "test", code: 0, userInfo: nil)
        publishSubject.asObserver().doOnce { (result, error) in
            doCount += 1
            doResult = result
            doError = error as NSError?
        }.subscribe().disposed(by: disposeBag!)
        
        disposeBag = nil
        publishSubject.onCompleted()
        publishSubject.onNext(10)
        publishSubject.onNext(20)
        publishSubject.onError(errorToPass)
        wait(timeout: 0.05)
        
        XCTAssertEqual(doCount, 1)
        XCTAssertNil(doError)
        XCTAssertNil(doResult)
    }
}

private enum TestError: Error {
    case test
}
