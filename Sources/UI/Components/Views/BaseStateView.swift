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
    var isActiveRelay: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)

    var isActiveDriver: Driver<Bool> {
        return isActiveRelay.asDriver()
    }
    
    var isActive: Bool {
        get {
            return isActiveRelay.value
        }
        set {
            isActiveRelay.accept(newValue)
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
        isActiveRelay.asDriver().map({$0 ? 1.0 : 0})
            .drive(self.rx.alpha)
            .disposed(by: disposeBag)
    }

    private func bindIsActiveToView() {
        isActiveRelay.asDriver().drive(
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
    
    // MARK: To override
    func createView() {
        // to override
    }
    
    func startActive() {
        showViewOnTop()
    }
    
    func stopActive() {
        // to override
    }
}
