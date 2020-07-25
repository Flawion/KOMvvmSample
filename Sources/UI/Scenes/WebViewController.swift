//
//  WebViewController.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit
import WebKit
import KOMvvmSampleLogic

final class WebViewController: BaseViewController<WebViewModelProtocol> {
    private weak var webView: WKWebView!
    
    // MARK: View controller functions
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
        prepareNavigationBar(withTitle: viewModel.barTitle)
    }

    private func loadData() {
        showLoadingView()
        if let html = viewModel.html {
            webView.loadHTMLString(html, baseURL: nil)
        } else if let url = viewModel.url {
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
        // TODO: it can be done in logic
        requestUrl = viewModel.relativeToServerIfNeed(url: requestUrl)
        guard let url = viewModel.url else {
            decisionHandler(.cancel)
            viewModel.openLink(requestUrl)
            return
        }
        
        if requestUrl.absoluteString == url.absoluteString {
            decisionHandler(.allow)
        } else {
            decisionHandler(.cancel)
            viewModel.openLink(url)
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
