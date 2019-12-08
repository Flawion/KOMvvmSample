//
//  UIView+Extension.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit

enum ConstraintsOperations {
    case equal
    case equalOrLess
    case equalOrGreater
}

enum ConstraintsDirections {
    case left
    case top
    case right
    case bottom

    case useForAll
}

struct AnchorsContainer {
    var left: NSLayoutXAxisAnchor?
    var top: NSLayoutYAxisAnchor?
    var right: NSLayoutXAxisAnchor?
    var bottom: NSLayoutYAxisAnchor?

    init(left: NSLayoutXAxisAnchor? = nil, top: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil) {
        self.left = left
        self.top = top
        self.right = right
        self.bottom = bottom
    }
}

struct ConstraintsContainer {
    var left: NSLayoutConstraint?
    var top: NSLayoutConstraint?
    var right: NSLayoutConstraint?
    var bottom: NSLayoutConstraint?

    var list: [NSLayoutConstraint] {
        var list: [NSLayoutConstraint] = []
        addToList(&list, ifNotNullConstraint: left)
        addToList(&list, ifNotNullConstraint: top)
        addToList(&list, ifNotNullConstraint: right)
        addToList(&list, ifNotNullConstraint: bottom)
        return list
    }

    private func addToList(_ list: inout [NSLayoutConstraint], ifNotNullConstraint constraint: NSLayoutConstraint?) {
        guard let constraint = constraint else {
            return
        }
        list.append(constraint)
    }
}

struct AddAutoLayoutSubviewSettings {
    var overrideAnchors: AnchorsContainer?
    var toAddConstraints: [ConstraintsDirections]
    var insets: UIEdgeInsets
    var operations: [ConstraintsDirections: ConstraintsOperations]
    var priorities: [ConstraintsDirections: Float]

    init(overrideAnchors: AnchorsContainer? = nil, toAddConstraints: [ConstraintsDirections] = [.left, .top, .right, .bottom], insets: UIEdgeInsets = UIEdgeInsets.zero, operations: [ConstraintsDirections: ConstraintsOperations] = [:], priorities: [ConstraintsDirections: Float] = [:]) {
        self.overrideAnchors = overrideAnchors
        self.toAddConstraints = toAddConstraints
        self.insets = insets
        self.operations = operations
        self.priorities = priorities
    }
}

extension UIView {
    func addSafeAutoLayoutSubview(_ view: UIView, overrideAnchors: AnchorsContainer? = nil, toAddConstraints: [ConstraintsDirections] = [.left, .top, .right, .bottom]) -> ConstraintsContainer {
        return addSafeAutoLayoutSubview(view, settings: AddAutoLayoutSubviewSettings(overrideAnchors: overrideAnchors, toAddConstraints: toAddConstraints))
    }

    func addSafeAutoLayoutSubview(_ view: UIView, settings: AddAutoLayoutSubviewSettings = AddAutoLayoutSubviewSettings()) -> ConstraintsContainer {
        var newSettings = settings
        newSettings.overrideAnchors = AnchorsContainer(left: settings.overrideAnchors?.left ?? safeAreaLayoutGuide.leftAnchor,
                                                         top: settings.overrideAnchors?.top ?? safeAreaLayoutGuide.topAnchor,
                                                         right: settings.overrideAnchors?.right ?? safeAreaLayoutGuide.rightAnchor,
                                                         bottom: settings.overrideAnchors?.bottom ?? safeAreaLayoutGuide.bottomAnchor)

        return addAutoLayoutSubview(view, settings: newSettings)
    }

    func addAutoLayoutSubview(_ view: UIView, overrideAnchors: AnchorsContainer? = nil, toAddConstraints: [ConstraintsDirections] = [.left, .top, .right, .bottom]) -> ConstraintsContainer {
        return addAutoLayoutSubview(view, settings: AddAutoLayoutSubviewSettings(overrideAnchors: overrideAnchors, toAddConstraints: toAddConstraints))
    }

    func addAutoLayoutSubview(_ view: UIView, settings: AddAutoLayoutSubviewSettings = AddAutoLayoutSubviewSettings()) -> ConstraintsContainer {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        let constraintsContainer = createConstraintsContainer(forAddingView: view, settings: settings)
        addConstraints(constraintsContainer.list)
        return constraintsContainer
    }

    private func createConstraintsContainer(forAddingView view: UIView, settings: AddAutoLayoutSubviewSettings) -> ConstraintsContainer {
        var constraintsContainer = ConstraintsContainer()
        constraintsContainer.left = tryToCreateLeftConstraint(addingView: view, settings: settings)
        constraintsContainer.top = tryToCreateTopConstraint(addingView: view, settings: settings)
        constraintsContainer.right = tryToCreateRightConstraint(addingView: view, settings: settings)
        constraintsContainer.bottom = tryToCreateBottomConstraint(addingView: view, settings: settings)
        return constraintsContainer
    }

    private func tryToCreateLeftConstraint(addingView view: UIView, settings: AddAutoLayoutSubviewSettings) -> NSLayoutConstraint? {
        guard settings.toAddConstraints.contains(.left) else {
            return nil
        }
        return createConstraints(fromAnchor: view.leftAnchor, toAnchor: (settings.overrideAnchors?.left ?? leftAnchor), operation: operation(settings.operations, forDirection: .left), priority: priority(settings.priorities, forDirection: .left), inset: settings.insets.left)
    }

    private func tryToCreateTopConstraint(addingView view: UIView, settings: AddAutoLayoutSubviewSettings) -> NSLayoutConstraint? {
        guard settings.toAddConstraints.contains(.top) else {
            return nil
        }
        return createConstraints(fromAnchor: view.topAnchor, toAnchor: (settings.overrideAnchors?.top ?? topAnchor), operation: operation(settings.operations, forDirection: .top), priority: priority(settings.priorities, forDirection: .top), inset: settings.insets.top)
    }

    private func tryToCreateRightConstraint(addingView view: UIView, settings: AddAutoLayoutSubviewSettings) -> NSLayoutConstraint? {
        guard settings.toAddConstraints.contains(.right) else {
            return nil
        }
        return createConstraints(fromAnchor: view.rightAnchor, toAnchor: (settings.overrideAnchors?.right ?? rightAnchor), operation: operation(settings.operations, forDirection: .right), priority: priority(settings.priorities, forDirection: .right), inset: -settings.insets.right)
    }

    private func tryToCreateBottomConstraint(addingView view: UIView, settings: AddAutoLayoutSubviewSettings) -> NSLayoutConstraint? {
        guard settings.toAddConstraints.contains(.bottom) else {
            return nil
        }
        return createConstraints(fromAnchor: view.bottomAnchor, toAnchor: (settings.overrideAnchors?.bottom ?? bottomAnchor), operation: operation(settings.operations, forDirection: .bottom), priority: priority(settings.priorities, forDirection: .bottom), inset: -settings.insets.bottom)
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

    private func operation(_ operations: [ConstraintsDirections: ConstraintsOperations], forDirection direction: ConstraintsDirections) -> ConstraintsOperations {
        if let operations = operations[.useForAll] {
            return operations
        }
        return operations[direction] ?? .equal
    }

    private func priority(_ priorities: [ConstraintsDirections: Float], forDirection direction: ConstraintsDirections) -> Float {
        if let priority = priorities[.useForAll] {
            return priority
        }
        return priorities[direction] ?? UILayoutPriority.required.rawValue
    }
}
