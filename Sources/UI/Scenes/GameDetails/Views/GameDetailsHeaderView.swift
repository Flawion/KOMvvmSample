//
//  GameDetailsHeaderView.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

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

    var needToResizeHeaderSubject: PublishSubject<Void> = PublishSubject<Void>()

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
        _ = addAutoLayoutSubview(imageLogoView, settings: createAddLayoutSubviewSettingsForImageLogoView())
        self.imageLogoView = imageLogoView

        createImageLogoSizeConstraints()
        bindImageLogo()
    }

    private func createAddLayoutSubviewSettingsForImageLogoView() -> AddAutoLayoutSubviewSettings {
        var addAutoLayoutSubviewSettings = AddAutoLayoutSubviewSettings()
        addAutoLayoutSubviewSettings.toAddConstraints = [.left, .top, .bottom]
        addAutoLayoutSubviewSettings.insets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        addAutoLayoutSubviewSettings.operations = [.bottom: .equalOrLess]
        addAutoLayoutSubviewSettings.priorities = [.useForAll: 999]
        return addAutoLayoutSubviewSettings
    }

    private func createImageLogoSizeConstraints() {
        let imageLogoHeightConst = imageLogoView.heightAnchor.constraint(equalToConstant: 130).withPriority(999)
        imageLogoView.addConstraints([
            imageLogoView.widthAnchor.constraint(equalToConstant: imageLogoWidth).withPriority(999),
            imageLogoHeightConst
            ])
        self.imageLogoHeightConst = imageLogoHeightConst
    }

    private func bindImageLogo() {
        controllerProtocol?.viewModel.gameDriver
            .map({$0.image?.mediumUrl})
            .drive(onNext: { [weak self] url in
                self?.setImageLogo(fromUrl: url)
            }).disposed(by: disposeBag)
    }

    private func setImageLogo(fromUrl url: URL?) {
        guard let url = url else {
            return
        }
        imageLogoView.setImageFade(url: url, completion: {
            DispatchQueue.main.async { [weak self] in
               self?.recalculateImageLogoHeight()
            }
        })
    }

    private func recalculateImageLogoHeight() {
        guard let image = imageLogoView?.image else {
            return
        }

        let heightRatio = image.size.height / image.size.width
        let imageHeight = imageLogoWidth * heightRatio
        imageLogoHeightConst.constant = imageHeight
        layoutIfNeeded()
        needToResizeHeaderSubject.onNext(())
    }
    
    private func initializeInfoView() {
        let infoPanelView = GameDetailsHeaderInfoView(controllerProtocol: controllerProtocol)
        _ = addAutoLayoutSubview(infoPanelView, settings: createAddAutoLayoutSubviewSettings(forInfoPanel: infoPanelView))
        self.infoView = infoPanelView
    }

    private func createAddAutoLayoutSubviewSettings(forInfoPanel infoPanelView: GameDetailsHeaderInfoView) -> AddAutoLayoutSubviewSettings {
        var addAutoLayoutSubviewSettings = AddAutoLayoutSubviewSettings()
        addAutoLayoutSubviewSettings.overrideAnchors = AnchorsContainer(left: imageLogoView.rightAnchor)
        addAutoLayoutSubviewSettings.insets = UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 8)
        addAutoLayoutSubviewSettings.priorities = [.useForAll: 999]
        return addAutoLayoutSubviewSettings
    }
}
