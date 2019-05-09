//
//  LoadingView.swift
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
        Navigator.shared.blockAllUserInteraction = !isActive
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
