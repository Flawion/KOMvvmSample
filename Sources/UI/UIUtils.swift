//
//  UIUtils.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation

final class UIUtils {
    static func createHorizontalViewsSlider(viewCount: Int, spacer: CGFloat = 0, createViewAtIndex: (_: Int) -> UIView, createEmptyView: () -> UIView) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false

        let contentView = createHorizontalContentOfViewsSlider(viewCount: viewCount, spacer: spacer, createViewAtIndex: createViewAtIndex, createEmptyView: createEmptyView)
        _ = scrollView.addAutoLayoutSubview(contentView)

        return scrollView
    }

    static private func createHorizontalContentOfViewsSlider(viewCount: Int, spacer: CGFloat = 0, createViewAtIndex: (_: Int) -> UIView, createEmptyView: () -> UIView) -> UIView {
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

    static private func createOnlyEmptyViewIfNeed(contentView: UIView, viewCount: Int, createEmptyView: () -> UIView) -> Bool {
        guard viewCount <= 0 else {
            return false
        }
        let emptyView = createEmptyView()
        _ = contentView.addAutoLayoutSubview(emptyView)
        return true
    }

    static private func createNextViewInHorizontalContentView(_ contentView: UIView, atIndex index: Int, spacer: CGFloat = 0, createViewAtIndex: (_: Int) -> UIView) {
        let previousViewRightAnchor = contentView.subviews.last?.rightAnchor
        let viewToAdd = createViewAtIndex(index)
        _ = contentView.addAutoLayoutSubview(viewToAdd, toAddConstraints: [.top, .bottom])

        // left
        if let previousViewRightAnchor = previousViewRightAnchor {
            contentView.addConstraint(viewToAdd.leftAnchor.constraint(equalTo: previousViewRightAnchor, constant: spacer))
        } else {
            contentView.addConstraint(viewToAdd.leftAnchor.constraint(equalTo: contentView.leftAnchor))
        }
    }

    static private func connectLastSubviewRightAnchor(toContentView contentView: UIView) {
        if let lastSubview = contentView.subviews.last {
            contentView.addConstraint(lastSubview.rightAnchor.constraint(equalTo: contentView.rightAnchor))
        }
    }
}
