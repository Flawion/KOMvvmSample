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
        //creates scroll view
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false

        //creates content view
        let contentView = Utils.shared.createHorizontalContentOfViewsSlider(viewCount: viewCount, spacer: spacer, createViewAtIndex: createViewAtIndex, createEmptyView: createEmptyView)
        _ = scrollView.addAutoLayoutSubview(contentView)

        return scrollView
    }

    func createHorizontalContentOfViewsSlider(viewCount: Int, spacer: CGFloat = 0, createViewAtIndex: (_: Int) -> UIView, createEmptyView: () -> UIView) -> UIView {
        let contentView = UIView()

        //checks if need to create only empty view
        guard viewCount > 0 else {
            let emptyView = createEmptyView()
            _ = contentView.addAutoLayoutSubview(emptyView)
            return contentView
        }

        //creates whole content
        var previousRightAnchor: NSLayoutXAxisAnchor?

        for index in 0..<viewCount {
            //creates view to add
            let viewToAdd = createViewAtIndex(index)
            _ = contentView.addAutoLayoutSubview(viewToAdd, toAddConstraints: [.top, .bottom])

            //left
            if let previousRightAnchor = previousRightAnchor {
                contentView.addConstraint(viewToAdd.leftAnchor.constraint(equalTo: previousRightAnchor, constant: spacer))
            } else {
                contentView.addConstraint(viewToAdd.leftAnchor.constraint(equalTo: contentView.leftAnchor))
            }

            //right end
            if index == (viewCount - 1) {
                contentView.addConstraint(viewToAdd.rightAnchor.constraint(equalTo: contentView.rightAnchor))
            }
            previousRightAnchor = viewToAdd.rightAnchor
        }

        return contentView
    }
}
