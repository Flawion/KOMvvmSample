//
//  WebViewModel.swift
//  KOMvvmSample
//
//  Created by Kuba Ostrowski on 09/06/2020.
//

import Foundation

final class WebViewModel: BaseViewModel {
    let barTitle: String
    let html: String?
    let url: URL?
    
    private static var appendingHTML: String {
        //will be added to properly scale viewport
        return "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>"
    }
    
    init(appCoordinator: AppCoordinatorProtocol, barTitle: String, html: String?) {
        self.barTitle = barTitle
        self.html = html?.appending(WebViewModel.appendingHTML)
        self.url = nil
        super.init(appCoordinator: appCoordinator)
    }
    
    init(appCoordinator: AppCoordinatorProtocol, barTitle: String, url: URL?) {
        self.barTitle = barTitle
        self.html = nil
        self.url = url
        super.init(appCoordinator: appCoordinator)
    }
    
    func openLink(_ url: URL) {
        appCoordinator?.openLink(url)
    }
}
