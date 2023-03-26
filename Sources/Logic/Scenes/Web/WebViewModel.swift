//
//  WebViewModel.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation

final class WebViewModel: BaseViewModel {
    let barTitle: String
    let html: String?
    let url: URL?
    
    private static var appendingHTML: String {
        // will be added to properly scale viewport
        return "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>"
    }
    
    init(appCoordinator: AppCoordinatorProtocol, barTitle: String, html: String?) {
        self.barTitle = barTitle
        if let html = html {
            self.html = WebViewModel.appendingHTML + html
        } else {
            self.html = nil
        }
        self.url = nil
        super.init(appCoordinator: appCoordinator)
    }
    
    init(appCoordinator: AppCoordinatorProtocol, barTitle: String, url: URL?) {
        self.barTitle = barTitle
        self.html = nil
        self.url = url
        super.init(appCoordinator: appCoordinator)
    }
}

// MARK: - WebViewModelProtocol
extension WebViewModel: WebViewModelProtocol {
    
    func tryToHandle(activatedUrl: URL) -> Bool {
        let requestUrl = relativeToServerIfNeed(url: activatedUrl)
        guard let entryUrl = url else {
            openLink(requestUrl)
            return true
        }
        guard requestUrl.absoluteString != entryUrl.absoluteString else {
            return false
        }
        openLink(requestUrl)
        return true
    }
    
    private func relativeToServerIfNeed(url: URL) -> URL {
        guard url.host == nil, let urlRelativeToServer = URL(string: AppSettings.Api.giantBombAddress + url.absoluteString) else {
            return url
        }
        return urlRelativeToServer
    }
    
    private func openLink(_ url: URL) {
        appCoordinator?.openLink(url)
    }
}
