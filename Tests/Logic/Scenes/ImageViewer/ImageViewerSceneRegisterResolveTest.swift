//
//  ImageViewerSceneRegisterResolveTest.swift
//  KOMvvmSampleLogicTests
//
//  Copyright (c) 2020 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import XCTest
import KOInject

@testable import KOMvvmSampleLogic

final class ImageViewerSceneRegisterResolveTest: XCTestCase {
    
    func test() {
        let appCoordinator = TestAppCoordinator()
        let imageUrl = URL(string: "https://github.githubassets.com/images/modules/open_graph/github-mark.png")!
        let image = ImageModel(iconUrl: imageUrl, mediumUrl: imageUrl, screenUrl: imageUrl, screenLargeUrl: imageUrl, smallUrl: imageUrl, superUrl: imageUrl, thumbUrl: imageUrl, tinyUrl: imageUrl, original: imageUrl, imageTags: "tags")
        
        ImageViewerViewModelRegister().register(register: appCoordinator.iocContainer)
        let viewController = ImageViewerSceneResolver(image: image).resolve(withAppCoordinator: appCoordinator, resolver: appCoordinator.iocContainer)
        
        XCTAssertNotNil(viewController)
        XCTAssertTrue(viewController is MockedViewController<ImageViewerViewModelProtocol>)
    }
}

// MARK: - TestAppCoordinator
private class TestAppCoordinator: BaseAppCoordinator {
    let iocContainer = KOIContainer()
    
    override init() {
        super.init(iocContainer: iocContainer)
    }
    
    override func registerViewControllers(register: KOIRegisterProtocol) {
        register.register(forType: ImageViewerViewControllerProtocol.self, scope: .separate) { (resolver, appCoordinator: AppCoordinatorProtocol, image: ImageModel) in
            guard let viewModel: ImageViewerViewModelProtocol = resolver.resolve(arg1: appCoordinator, arg2: image) else {
                fatalError()
            }
            return MockedViewController(viewModel: viewModel)
        }
    }
}
