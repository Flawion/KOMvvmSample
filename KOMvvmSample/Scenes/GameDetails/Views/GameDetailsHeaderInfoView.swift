//
//  GameDetailsHeaderInfoView.swift
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

final class GameDetailsHeaderInfoView: UIView {
    // MARK: Variables
    private weak var controllerProtocol: GameDetailsViewControllerProtocol?

    //info panel content
    private weak var releaseDateLabel: BaseLabel!
    private weak var infoSeparatorLine: SeparatorLineView!
    private weak var platformsScrollView: UIScrollView!
    private weak var deckLabel: BaseLabel!
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

    private func initialize() {
        initializeReleaseDateLabel()
        initializeInfoSeparatorLine()
        initializePlatformsScrollView()
        initializeDeckLabel()
        addInfoPanelVerticalConstraints()
        bindInfoPanelContent()
    }

    private func initializeReleaseDateLabel() {
        let releaseDateLabel = BaseLabel()
        releaseDateLabel.numberOfLines = 0
        releaseDateLabel.lineBreakMode = .byWordWrapping
        releaseDateLabel.font = UIFont.Theme.gameDetailsHeaderReleaseDateLabel
        releaseDateLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 500), for: .vertical)
        releaseDateLabel.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .vertical)
        _ = addAutoLayoutSubview(releaseDateLabel, toAddConstraints: [.left, .right])
        self.releaseDateLabel = releaseDateLabel
    }

    private func initializeInfoSeparatorLine() {
        let infoSeparatorLine = SeparatorLineView()
        _ = addAutoLayoutSubview(infoSeparatorLine, toAddConstraints: [.left, .right])
        infoSeparatorLine.addConstraint(infoSeparatorLine.heightAnchor.constraint(equalToConstant: 1))
        self.infoSeparatorLine = infoSeparatorLine
    }

    private func initializePlatformsScrollView() {
        let platformsScrollView = Utils.shared.createHorizontalViewsSlider(viewCount: controllerProtocol?.viewModel.game.platforms?.count ?? 0, spacer: 2, createViewAtIndex: { [weak self](index) -> UIView in
            let platformLabel = BaseLabel()
            guard let self = self, let platforms = self.controllerProtocol?.viewModel.game.platforms else {
                return platformLabel
            }
            platformLabel.text = (platforms[index].name)  + (index < (platforms.count - 1) ? ", " : "")
            return platformLabel

            }, createEmptyView: {
                let emptyLabel = BaseLabel()
                emptyLabel.text = "game_details_unspecified_platforms".localized
                return emptyLabel

        })
        _ = addAutoLayoutSubview(platformsScrollView, toAddConstraints: [.left, .right])
        platformsScrollView.addConstraint(platformsScrollView.heightAnchor.constraint(equalToConstant: 30))
        self.platformsScrollView = platformsScrollView
    }

    private func initializeDeckLabel() {
        let deckLabel = BaseLabel()
        deckLabel.lineBreakMode = .byWordWrapping
        deckLabel.numberOfLines = 0
        deckLabel.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .vertical)
        _ = addAutoLayoutSubview(deckLabel, toAddConstraints: [.left, .right])
        self.deckLabel = deckLabel
    }

    private func addInfoPanelVerticalConstraints() {
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[releaseDateLabel]-8-[infoSeparatorLine]-2-[platformsScrollView]-2-[deckLabel]|", options: [], metrics: nil, views: ["releaseDateLabel": releaseDateLabel, "infoSeparatorLine": infoSeparatorLine, "platformsScrollView": platformsScrollView, "deckLabel": deckLabel]))
    }

    private func bindInfoPanelContent() {
        guard let controllerProtocol = controllerProtocol else {
            return
        }
        let gameDriverShared = controllerProtocol.viewModel.gameDriver.asSharedSequence()
        gameDriverShared.map({$0.orginalOrExpectedReleaseDateString}).drive(releaseDateLabel.rx.text).disposed(by: disposeBag)
        gameDriverShared.map({$0.deck}).drive(deckLabel.rx.text).disposed(by: disposeBag)
    }
}
