//
//  BaseDataControllerTests.swift
//  KOMvvmSampleLogicTests
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import XCTest
import RxSwift
import RxCocoa
import RxBlocking
import RxTest

@testable import KOMvvmSampleLogic

final class BaseDataControllerTests: XCTestCase {
    private var baseDataController: BaseDataController!
    
    override func setUp() {
        baseDataController = BaseDataController()
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        baseDataController = nil
    }
    
    func testDataActionStateChanged() {
        baseDataController.dataActionState = .empty
        XCTAssertEqual(baseDataController.dataActionState, .empty)
    }
    
    func testDataActionStateDriverChanged() throws {
        baseDataController.dataActionState = .loading
        XCTAssertEqual(try baseDataController.dataActionStateDriver.toBlocking().first(), .loading)
    }
    
    func testRaiseError() {
        let testScheduler = TestScheduler(initialClock: 0)
        let disposeBag = DisposeBag()
        let observer = testScheduler.createObserver(NSError.self)
        let expectedError: [Recorded<Event<NSError>>] = [Recorded.next(15, AppError(withCode: .commonSelfNotExists)),
                                                         Recorded.next(30, AppError(withCode: .commonDriverDefault))]
        
        baseDataController.raiseErrorDriver.map({ $0 as NSError }).drive(observer).disposed(by: disposeBag)
        testScheduler.createHotObservable(expectedError)
            .subscribe(onNext: { [weak self] error in
                self?.baseDataController.raise(error: error)
            }).disposed(by: disposeBag)
        testScheduler.start()
        
        XCTAssertEqual(observer.events, expectedError)
    }
}
