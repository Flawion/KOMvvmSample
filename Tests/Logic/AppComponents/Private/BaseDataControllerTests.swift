//
//  BaseDataControllerTests.swift
//  KOMvvmSampleLogicTests
//
//  Created by Kuba Ostrowski on 26/07/2020.
//

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
        let expectedError: [Recorded<Event<NSError>>] = [Recorded.next(15, AppError.commonSelfNotExists),
                                                     Recorded.next(30, AppError.commonDriverDefault)]
        
        baseDataController.raiseErrorDriver.map({ $0 as NSError }).drive(observer).disposed(by: disposeBag)
        testScheduler.createHotObservable(expectedError)
            .subscribe(onNext: { [weak self] error in
                self?.baseDataController.raise(error: error)
            }).disposed(by: disposeBag)
        testScheduler.start()
        
        XCTAssertEqual(observer.events, expectedError)
    }
}
