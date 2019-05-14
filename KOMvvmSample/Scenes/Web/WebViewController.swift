//
//  WebViewController.swift
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

    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }

    private func initialize() {
        initializeView()
        initializeWebView()
        bindLoading()
        loadData()
    }

    private func initializeView() {
        prepareNavigationBar(withTitle: barTitle)
    }
    
    private func initializeWebView() {
        let webView = WKWebView()
        webView.navigationDelegate = self
        _ = view.addSafeAutoLayoutSubview(webView)
        self.webView = webView
    }

    private func bindLoading() {
        //show/hide actualization when loading
        let isLoadingDrive = webView.rx.observe(Bool.self, "loading")
            .asDriver(onErrorJustReturn: false)

        isLoadingDrive.map({($0 ?? false)})
            .drive(loadingView.isActiveVar).disposed(by: disposeBag)
    }

    private func loadData() {
        if let html = html {
            webView.loadHTMLString(html, baseURL: nil)
        } else if let url = url {
            webView.load(URLRequest(url: url))
        }
    }
}

// MARK: - WKNavigationDelegate
extension WebViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        guard let requestUrl = navigationAction.request.url, navigationAction.navigationType == .linkActivated else {
            decisionHandler(.allow)
            return
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
}
