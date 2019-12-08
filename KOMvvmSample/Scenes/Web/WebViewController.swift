//
//  WebViewController.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit
import WebKit

final class WebViewController: BaseViewController {
    private let barTitle: String
    private var html: String?
    private var url: URL?

    private weak var webView: WKWebView!

    var appendingHTML: String {
        //will be added to properly scale viewport
        return "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>"
    }

    init(barTitle: String, html: String) {
        self.barTitle = barTitle

        super.init(nibName: nil, bundle: nil)
        self.html = html.appending(appendingHTML)
    }

    init(barTitle: String, url: URL?) {
        self.barTitle = barTitle

        super.init(nibName: nil, bundle: nil)
        self.url = url
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        self.webView = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }

    private func initialize() {
        initializeView()
        loadData()
    }

    private func initializeView() {
        prepareNavigationBar(withTitle: barTitle)
    }

    private func loadData() {
        showLoadingView()
        if let html = html {
            webView.loadHTMLString(html, baseURL: nil)
        } else if let url = url {
            webView.load(URLRequest(url: url))
        }
    }

    private func showLoadingView() {
        loadingView.isActive = true
    }

    private func hideLoadingView() {
        loadingView.isActive = false
    }
}

// MARK: - WKNavigationDelegate
extension WebViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        guard var requestUrl = navigationAction.request.url, navigationAction.navigationType == .linkActivated else {
            decisionHandler(.allow)
            return
        }

        if requestUrl.host == nil, let newUrl = URL(string: AppSettings.Api.giantBombAddress + requestUrl.absoluteString) {
            requestUrl = newUrl
        }
        guard let url = url else {
            decisionHandler(.cancel)
            AppCoordinator.shared.openLink(requestUrl)
            return
        }

        if requestUrl.absoluteString == url.absoluteString {
            decisionHandler(.allow)
        } else {
            decisionHandler(.cancel)
            AppCoordinator.shared.openLink(url)
        }
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        hideLoadingView()
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        hideLoadingView()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideLoadingView()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hideLoadingView()
    }

}
