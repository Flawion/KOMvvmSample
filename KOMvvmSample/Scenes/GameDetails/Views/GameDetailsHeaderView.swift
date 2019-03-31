//
//  GameDetailsHeaderView.swift
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

final class GameDetailsHeaderView: UIView {
    // MARK: Variables
    private weak var controllerProtocol: GameDetailsViewControllerProtocol?

    private let imageLogoWidth: CGFloat = 100

    private weak var imageLogoView: BaseImageView!
    private weak var imageLogoHeightConst: NSLayoutConstraint!
    private weak var infoView: GameDetailsHeaderInfoView!

    private let disposeBag: DisposeBag = DisposeBag()
    
    // MARK: Initialization functions
    init(controllerProtocol: GameDetailsViewControllerProtocol?) {
        self.controllerProtocol = controllerProtocol
        super.init(frame: CGRect.zero)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    deinit {
        imageLogoView.sd_cancelCurrentImageLoad()
    }
    
    private func initialize() {
        initializeImageLogoView()
        initializeInfoView()
    }
    
    private func initializeImageLogoView() {
        let imageLogoView = BaseImageView()
        imageLogoView.contentMode = .scaleAspectFit
        imageLogoView.backgroundColor = UIColor.Theme.gameImageBackground
        _ = addAutoLayoutSubview(imageLogoView, toAddConstraints: [.left, .top, .bottom], insets: UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12), operations: [.bottom: .equalOrLess], priorities: [.useForAll: 999])
        let imageLogoHeightConst = imageLogoView.heightAnchor.constraint(equalToConstant: 130).withPriority(999)
        imageLogoView.addConstraints([
            imageLogoView.widthAnchor.constraint(equalToConstant: imageLogoWidth).withPriority(999),
            imageLogoHeightConst
            ])
        self.imageLogoView = imageLogoView
        self.imageLogoHeightConst = imageLogoHeightConst
        bindImageLogo()
    }

    private func bindImageLogo() {
        controllerProtocol?.viewModel.gameDriver.map({$0.image?.mediumUrl})
            .drive(onNext: { [weak self] url in
                guard let self = self, let url = url else {
                    return
                }
                self.imageLogoView.sd_setImageFade(url: url, completion: { [weak self] in
                    guard let self = self, let image = self.imageLogoView?.image else {
                        return
                    }

                    //calculates image height
                    let heightRatio = image.size.height / image.size.width
                    self.imageLogoHeightConst.constant = self.imageLogoWidth * heightRatio
                    DispatchQueue.main.async { [weak self] in
                        self?.layoutIfNeeded()
                    }
                })
            }).disposed(by: disposeBag)
    }
    
    private func initializeInfoView() {
        let infoPanelView = GameDetailsHeaderInfoView(controllerProtocol: controllerProtocol)
        _ = addAutoLayoutSubview(infoPanelView, overrideAnchors: OverrideAnchors(left: imageLogoView.rightAnchor), insets: UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 8), priorities: [.useForAll: 999])
        self.infoView = infoPanelView
    }
}
