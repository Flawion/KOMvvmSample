//
//  LoadingView.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit
import RxSwift
import RxCocoa

class BaseStateView: UIView {
    // MARK: Variables
    private let disposeBag = DisposeBag()
    
    //public
    var isActiveVar: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    var manageBlockingAllUserInteraction: Bool = false
    
    var isActiveDriver: Driver<Bool> {
        return isActiveVar.asDriver()
    }
    
    var isActive: Bool {
        get {
            return isActiveVar.value
        }
        set {
            isActiveVar.accept(newValue)
        }
    }
    
    // MARK: Initialization
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        backgroundColor = UIColor.clear
        createView()
        createBindings()
    }
    
    private func createBindings() {
        bindIsActiveToViewAlpha()
        bindIsActiveToView()
    }

    private func bindIsActiveToViewAlpha() {
        isActiveVar.asDriver().map({$0 ? 1.0 : 0})
            .drive(self.rx.alpha)
            .disposed(by: disposeBag)
    }

    private func bindIsActiveToView() {
        isActiveVar.asDriver().drive(
            onNext: { [weak self] isActive in
                self?.refreshIsActive(isActive)

        }).disposed(by: disposeBag)
    }

    private func refreshIsActive(_ isActive: Bool) {
        guard isActive else {
            stopActive()
            return
        }
        startActive()
    }

    private func showViewOnTop() {
        superview?.bringSubviewToFront(self)
    }

    private func refreshBlockingAllUserInteraction() {
        guard manageBlockingAllUserInteraction else {
            return
        }
        // TODO: do it in another way
       // AppCoordinator.shared.blockAllUserInteraction = !isActive
    }
    
    // MARK: To override
    func createView() {
        //to override
    }
    
    func startActive() {
        showViewOnTop()
        refreshBlockingAllUserInteraction()
    }
    
    func stopActive() {
        refreshBlockingAllUserInteraction()
    }
}
