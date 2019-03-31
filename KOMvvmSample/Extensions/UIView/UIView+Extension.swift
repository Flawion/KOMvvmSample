//
//  UIView+Extension.swift
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

struct ConstraintsContainer {
    var left: NSLayoutConstraint?
    var top: NSLayoutConstraint?
    var right: NSLayoutConstraint?
    var bottom: NSLayoutConstraint?
}

extension UIView {
    //- MARK: Constraints helpers
    // MARK: Private
    private func priority(_ priorities: [ConstraintsDirections: Float], forDirection direction: ConstraintsDirections) -> Float {
        if let priority = priorities[.useForAll] {
            return priority
        }
        return priorities[direction] ?? UILayoutPriority.required.rawValue
    }

    private func operation(_ operations: [ConstraintsDirections: ConstraintsOperations], forDirection direction: ConstraintsDirections) -> ConstraintsOperations {
        if let operations = operations[.useForAll] {
            return operations
        }
        return operations[direction] ?? .equal
    }

    private func createConstraints<Axis>(fromAnchor anchor: NSLayoutAnchor<Axis>, toAnchor: NSLayoutAnchor<Axis>, operation: ConstraintsOperations, priority: Float, inset: CGFloat) -> NSLayoutConstraint {
        switch operation {
        case .equal:
            return anchor.constraint(equalTo: toAnchor, constant: inset).withPriority(priority)
        case .equalOrGreater:
            return anchor.constraint(greaterThanOrEqualTo: toAnchor, constant: inset).withPriority(priority)
        case .equalOrLess:
            return anchor.constraint(lessThanOrEqualTo: toAnchor, constant: inset).withPriority(priority)
        }
    }

    // MARK: Public
    func addAutoLayoutSubview(_ view: UIView, overrideAnchors: OverrideAnchors? = nil, toAddConstraints: [ConstraintsDirections] = [.left, .top, .right, .bottom], insets: UIEdgeInsets = UIEdgeInsets.zero, operations: [ConstraintsDirections: ConstraintsOperations] = [:], priorities: [ConstraintsDirections: Float] = [:]) -> ConstraintsContainer {

        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)

        var constraintsContainer = ConstraintsContainer()
        var constraints: [NSLayoutConstraint] = []
        if toAddConstraints.contains(.left) {
            let constraint = createConstraints(fromAnchor: view.leftAnchor, toAnchor: (overrideAnchors?.left ?? leftAnchor), operation: operation(operations, forDirection: .left), priority: priority(priorities, forDirection: .left), inset: insets.left)
            constraintsContainer.left = constraint
            constraints.append(constraint)
        }
        if toAddConstraints.contains(.top) {
            let constraint = createConstraints(fromAnchor: view.topAnchor, toAnchor: (overrideAnchors?.top ?? topAnchor), operation: operation(operations, forDirection: .top), priority: priority(priorities, forDirection: .top), inset: insets.top)
            constraintsContainer.top = constraint
            constraints.append(constraint)
        }
        if toAddConstraints.contains(.right) {
            let constraint = createConstraints(fromAnchor: view.rightAnchor, toAnchor: (overrideAnchors?.right ?? rightAnchor), operation: operation(operations, forDirection: .right), priority: priority(priorities, forDirection: .right), inset: -insets.right)
            constraintsContainer.right = constraint
            constraints.append(constraint)
        }
        if toAddConstraints.contains(.bottom) {
            let constraint = createConstraints(fromAnchor: view.bottomAnchor, toAnchor: (overrideAnchors?.bottom ?? bottomAnchor), operation: operation(operations, forDirection: .bottom), priority: priority(priorities, forDirection: .bottom), inset: -insets.bottom)
            constraintsContainer.bottom = constraint
            constraints.append(constraint)
        }

        addConstraints(constraints)
        return constraintsContainer
    }

    func addSafeAutoLayoutSubview(_ view: UIView, overrideAnchors: OverrideAnchors? = nil, toAddConstraints: [ConstraintsDirections] = [.left, .top, .right, .bottom], insets: UIEdgeInsets = UIEdgeInsets.zero, operations: [ConstraintsDirections: ConstraintsOperations] = [:], priorities: [ConstraintsDirections: Float] = [:]) -> ConstraintsContainer {
        return addAutoLayoutSubview(view, overrideAnchors: OverrideAnchors(left: overrideAnchors?.left ?? safeAreaLayoutGuide.leftAnchor, top: overrideAnchors?.top ?? safeAreaLayoutGuide.topAnchor, right: overrideAnchors?.right ?? safeAreaLayoutGuide.rightAnchor, bottom: overrideAnchors?.bottom ?? safeAreaLayoutGuide.bottomAnchor), toAddConstraints: toAddConstraints, insets: insets, operations: operations, priorities: priorities)
    }
}
