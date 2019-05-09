//
//  Navigator.swift
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

import UIKit

final class Navigator {
    // MARK: Variables
    static let shared = {
        return Navigator()
    }()
    
    private var window: UIWindow?

    /// Blocking all user interaction on UIWindow can be used in animation
    var blockAllUserInteraction: Bool {
        get {
            return window?.isUserInteractionEnabled ?? false
        }
        set {
            window?.isUserInteractionEnabled = newValue
        }
    }
    
    // MARK: Initialization
    private init() {}
    
    func initializeScene() {
        window = UIWindow()
        window?.makeKeyAndVisible()
        createFirstScene()
    }
    
    private func createFirstScene() {
        guard let window = window else {
            return
        }
        window.rootViewController = createMainNavigationController()
    }

    private func createMainNavigationController() -> UINavigationController {
        let mainNavigationController = UINavigationController(rootViewController: GamesViewController())
        mainNavigationController.navigationBar.tintColor = UIColor.Theme.barTint
        mainNavigationController.navigationBar.backgroundColor = UIColor.Theme.barBackground
        return mainNavigationController
    }
    
    // MARK: Actions
    func openLink(_ url: URL) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    // MARK: Push new view controllers
    private func push(viewController: UIViewController, onNavigationController: UINavigationController?, animated: Bool = true) {
        guard let onNavigationController = onNavigationController else {
            return
        }
        onNavigationController.pushViewController(viewController, animated: animated)
    }

    //public
    func pushGameDetail(forGame game: GameModel, onNavigationController: UINavigationController?, animated: Bool = true) {
        push(viewController: GameDetailsViewController(game: game), onNavigationController: onNavigationController, animated: animated)
    }

    func pushGamesFilters(currentFilters: [GamesFilters: String], onNavigationController: UINavigationController?, animated: Bool = true) -> GamesFiltersViewControllerProtocol {
        let gamesFilters = GamesFiltersViewController(currentFilters: currentFilters)
        push(viewController: gamesFilters, onNavigationController: onNavigationController)
        return gamesFilters
    }

    func pushWebView(barTitle: String, html: String, onNavigationController: UINavigationController?, animated: Bool = true) {
        push(viewController: WebViewController(barTitle: barTitle, html: html), onNavigationController: onNavigationController)
    }

    func pushGameImages(_ images: [ImageModel], onNavigationController: UINavigationController?, animated: Bool = true) {
        push(viewController: GameImagesViewController(images: images), onNavigationController: onNavigationController, animated: animated)
    }

    func pushImageViewer(image: ImageModel, onNavigationController: UINavigationController?, animated: Bool = true) {
        push(viewController: ImageViewerViewController(image: image), onNavigationController: onNavigationController, animated: animated)
    }
}
