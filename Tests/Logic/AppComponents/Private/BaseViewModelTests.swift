//
//  BaseViewModelTests.swift
//  KOMvvmSampleLogicTests
//
//  Created by Kuba Ostrowski on 29/07/2020.
//

import XCTest
import RxTest
import RxSwift
import RxCocoa
import RxBlocking

@testable import KOMvvmSampleLogic

final class BaseViewModelTests: XCTestCase {
    private var appCoordinator: TestAppCoordinator!
    private var baseViewModel: BaseViewModel!
    
    override func setUp() {
        appCoordinator = TestAppCoordinator()
        baseViewModel = BaseViewModel(appCoordinator: appCoordinator)
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        appCoordinator = nil
        baseViewModel = nil
    }
    
    func testInitialize() {
        XCTAssertNotNil(baseViewModel.appCoordinator)
    }
    
    func testForwardDataActionState() {
        let testScheduler = TestScheduler(initialClock: 0)
        let disposeBag = DisposeBag()
        let expectedEvents = [Recorded.next(0, DataActionStates.none), Recorded.next(15, DataActionStates.loading), Recorded.next(30, DataActionStates.error), Recorded.next(45, DataActionStates.loading), Recorded.next(60, DataActionStates.empty) ]
        var changeEvents = expectedEvents
        changeEvents.removeFirst()
        
        let dataActionStateObserver = testScheduler.createObserver(DataActionStates.self)
        baseViewModel.dataActionStateDriver.drive(dataActionStateObserver).disposed(by: disposeBag)
        testScheduler.createHotObservable(changeEvents).subscribe(onNext: { [weak self] dataActionState in
            self?.baseViewModel.dataActionState = dataActionState
            }).disposed(by: disposeBag)
        testScheduler.start()
        
        XCTAssertEqual(dataActionStateObserver.events, expectedEvents)
    }
    
    func testForwardRaiseError() {
        let testScheduler = TestScheduler(initialClock: 0)
        let disposeBag = DisposeBag()
        let expectedEvents = [Recorded.next(15, AppError.commonSelfNotExists), Recorded.next(30, AppError.commonDriverDefault)]
        
        let errorObserver = testScheduler.createObserver(NSError.self)
        baseViewModel.raiseErrorDriver.map({ $0 as NSError}).drive(errorObserver).disposed(by: disposeBag)
        testScheduler.createHotObservable(expectedEvents).subscribe(onNext: { [weak self] error in
            self?.baseViewModel.raise(error: error)
            }).disposed(by: disposeBag)
        testScheduler.start()
        
        XCTAssertEqual(errorObserver.events, expectedEvents)
    }
}

// MARK: Testa data
private final class TestAppCoordinator: BaseAppCoordinator {
    override func registerViewControllers(builder: ScenesViewControllerBuilder) {
    }
    
    override func setWindowRootViewController() {
    }
}
