//
//  Utils+UI.swift
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

import Foundation

extension Utils {
    func createHorizontalViewsSlider(viewCount: Int, spacer: CGFloat = 0, createViewAtIndex: (_: Int) -> UIView, createEmptyView: () -> UIView) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false

        let contentView = Utils.shared.createHorizontalContentOfViewsSlider(viewCount: viewCount, spacer: spacer, createViewAtIndex: createViewAtIndex, createEmptyView: createEmptyView)
        _ = scrollView.addAutoLayoutSubview(contentView)

        return scrollView
    }

    func createHorizontalContentOfViewsSlider(viewCount: Int, spacer: CGFloat = 0, createViewAtIndex: (_: Int) -> UIView, createEmptyView: () -> UIView) -> UIView {
        let contentView = UIView()

        if createOnlyEmptyViewIfNeed(contentView: contentView, viewCount: viewCount, createEmptyView: createEmptyView) {
            return contentView
        }

        for index in 0..<viewCount {
            createNextViewInHorizontalContentView(contentView, atIndex: index, createViewAtIndex: createViewAtIndex)
        }
        connectLastSubviewRightAnchor(toContentView: contentView)

        return contentView
    }

    private func createOnlyEmptyViewIfNeed(contentView: UIView, viewCount: Int, createEmptyView: () -> UIView) -> Bool {
        guard viewCount <= 0 else {
            return false
        }
        let emptyView = createEmptyView()
        _ = contentView.addAutoLayoutSubview(emptyView)
        return true
    }

    private func createNextViewInHorizontalContentView(_ contentView: UIView, atIndex index: Int, spacer: CGFloat = 0, createViewAtIndex: (_: Int) -> UIView) {
        let previousViewRightAnchor = contentView.subviews.last?.rightAnchor
        let viewToAdd = createViewAtIndex(index)
        _ = contentView.addAutoLayoutSubview(viewToAdd, toAddConstraints: [.top, .bottom])

        //left
        if let previousViewRightAnchor = previousViewRightAnchor {
            contentView.addConstraint(viewToAdd.leftAnchor.constraint(equalTo: previousViewRightAnchor, constant: spacer))
        } else {
            contentView.addConstraint(viewToAdd.leftAnchor.constraint(equalTo: contentView.leftAnchor))
        }
    }

    private func connectLastSubviewRightAnchor(toContentView contentView: UIView) {
        if let lastSubview = contentView.subviews.last {
            contentView.addConstraint(lastSubview.rightAnchor.constraint(equalTo: contentView.rightAnchor))
        }
    }
}
