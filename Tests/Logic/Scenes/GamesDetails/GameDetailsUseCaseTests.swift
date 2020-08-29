//
//  GameDetailsUseCaseTests.swift
//  KOMvvmSampleLogicTests
//
//  Copyright (c) 2020 Kuba Ostrowskion 16/08/2020.
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import XCTest
import RxSwift
import RxCocoa
import RxTest
import RxBlocking

@testable import KOMvvmSampleLogic

final class GameDetailsUseCaseTests: XCTestCase {
    private var serviceLocator: ServiceLocator!
    private var mockGiantBombMockClientServiceBuilder: MockGiantBombMockClientServiceBuilder!
    private var giantBombMockClient: GiantBombMockClientService!
    private var gameDetailsUseCase: GameDetailsUseCase!
    
    override func setUp() {
        serviceLocator = ServiceLocator()
        let gameDetailsGuid = mockGiantBombMockClientServiceBuilder.gameDetailsGuid
        let gameDetailsName = mockGiantBombMockClientServiceBuilder.gameDetailsName
        let game = GameModel(testModelWithGuid: gameDetailsGuid, name: gameDetailsName)
        mockGiantBombMockClientServiceBuilder = MockGiantBombMockClientServiceBuilder(serviceLocator: serviceLocator)
        giantBombMockClient = MockGiantBombMockClientServiceBuilder(serviceLocator: serviceLocator).client
        gameDetailsUseCase = GameDetailsUseCase(game: game, giantBombClient: giantBombMockClient)
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        serviceLocator = nil
        mockGiantBombMockClientServiceBuilder = nil
        giantBombMockClient = nil
        gameDetailsUseCase = nil
    }
}
