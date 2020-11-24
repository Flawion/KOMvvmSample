//
//  GameDetailsFooterView.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation
import RxSwift
import RxCocoa
import KOMvvmSampleLogic

final class GameDetailsFooterView: UIView {
    // MARK: Variables
    private weak var controllerProtocol: UIGameDetailsViewControllerProtocol?
    private let disposeBag: DisposeBag = DisposeBag()

    // MARK: Initialization functions
    init(controllerProtocol: UIGameDetailsViewControllerProtocol?) {
        self.controllerProtocol = controllerProtocol
        super.init(frame: CGRect.zero)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    private func initialize() {
       bindGameDetailsToCreateInfo()
    }

    public func bindGameDetailsToCreateInfo() {
        controllerProtocol?.viewModel.gameDetailsDriver.drive(onNext: { [weak self] gameDetails in
            guard let self = self, let gameDetails = gameDetails else {
                return
            }
            self.createInfoViews(gameDetails: gameDetails)
            self.controllerProtocol?.resizeDetailsFooterView()
        }).disposed(by: disposeBag)
    }

    private func createInfoViews(gameDetails: GameDetailsModel) {
        let developerInfoView = createInfoView(forResources: gameDetails.developers, withTitle: "Developer")
        let publisherInfoView = createInfoView(forResources: gameDetails.publishers, withTitle: "Publisher")
        let generesInfoView = createInfoView(forResources: gameDetails.genres, withTitle: "Genere")
        let themeInfoView = createInfoView(forResources: gameDetails.themes, withTitle: "Theme")

        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[developer]-8-[publisher]-8-[genere]-8-[theme]-8-|", options: [], metrics: nil, views: ["developer": developerInfoView, "publisher": publisherInfoView, "genere": generesInfoView, "theme": themeInfoView]))
    }

    private func createInfoView(forResources resources: [ResourceModel]?, withTitle title: String) -> UIView {
        let infoView = UIView()
        _ = addAutoLayoutSubview(infoView, settings: createAddAutoLayoutSubviewSettings(forInfoView: infoView))

        let subtitleLabel = createSubtitleInfoLabel(withTitle: title, parent: infoView)
        let infoLabel = createInfoLabel(withInfo: getInfo(fromResources: resources), parent: infoView)

        infoView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subtitle]-2-[info]|", options: [], metrics: nil, views: ["subtitle": subtitleLabel, "info": infoLabel]))

        return infoView
    }

    private func createAddAutoLayoutSubviewSettings(forInfoView infoView: UIView) -> AddAutoLayoutSubviewSettings {
        var addAutoLayoutSubviewSettings = AddAutoLayoutSubviewSettings()
        addAutoLayoutSubviewSettings.toAddConstraints = [.left, .right]
        addAutoLayoutSubviewSettings.insets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        return addAutoLayoutSubviewSettings
    }

    private func createSubtitleInfoLabel(withTitle title: String, parent: UIView) -> UILabel {
        let subtitleLabel = SubtitleLabel()
        subtitleLabel.text = title
        subtitleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 500), for: .vertical)
        _ = parent.addAutoLayoutSubview(subtitleLabel, toAddConstraints: [.left, .right])
        return subtitleLabel
    }

    private func createInfoLabel(withInfo info: String, parent: UIView) -> UILabel {
        let infoLabel = BaseLabel()
        infoLabel.text = info
        infoLabel.numberOfLines = 0
        infoLabel.lineBreakMode = .byWordWrapping
        _ = parent.addAutoLayoutSubview(infoLabel, toAddConstraints: [.left, .right])
        return infoLabel
    }

    private func getInfo(fromResources resources: [ResourceModel]?) -> String {
        var info: String = ""
        let resources = resources ?? []
        for index in 0 ..< resources.count {
            info += resources[index].name  + (index < (resources.count - 1) ? ", " : "")
        }

        if info.isEmpty {
            info = "game_details_info_unspecified".localized
        }
        return info
    }
}
