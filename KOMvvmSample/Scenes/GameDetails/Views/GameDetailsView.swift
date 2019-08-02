//
//  GameDetailsView.swift
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

final class GameDetailsView: UIView {
    // MARK: Variables
    private weak var controllerProtocol: GameDetailsViewControllerProtocol?

    private let detailsItemCellReuseIdentifier: String = "GameDetailsItemViewCell"
   
    private var detailsHeaderView: GameDetailsHeaderView!
    private var detailsHeaderWidthConst: NSLayoutConstraint!
    
    private var detailsFooterView: GameDetailsFooterView!
    private var detailsFooterWidthConst: NSLayoutConstraint!
    
    private weak var detailsItemsTableView: UITableView!
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    // MARK: Initialization functions
    init(controllerProtocol: GameDetailsViewControllerProtocol) {
        self.controllerProtocol = controllerProtocol
        super.init(frame: CGRect.zero)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        resizeDetailsViews()
    }
    
    private func initialize() {
        initializeDetailsHeaderView()
        initializeDetailsFooterView()
        initializeDetailsItemsTableView()
    }
    
    private func initializeDetailsHeaderView() {
        detailsHeaderView = GameDetailsHeaderView(controllerProtocol: controllerProtocol)
        detailsHeaderWidthConst = detailsHeaderView.widthAnchor.constraint(equalToConstant: bounds.width).withPriority(999)
        detailsHeaderView.addConstraint(detailsHeaderWidthConst)
        bindNeedToResizeHeaderSubject()
    }

    private func bindNeedToResizeHeaderSubject() {
        detailsHeaderView.needToResizeHeaderSubject.subscribe(onNext: { [weak self] in
            self?.resizeDetailsHeaderView()
        }).disposed(by: disposeBag)
    }
    
    private func initializeDetailsFooterView() {
        detailsFooterView = GameDetailsFooterView(controllerProtocol: controllerProtocol)
        detailsFooterWidthConst = detailsFooterView.widthAnchor.constraint(equalToConstant: bounds.width).withPriority(999)
        detailsFooterView.addConstraints([
            detailsFooterWidthConst,
            detailsFooterView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100).withPriority(999)
            ])
    }
    
    private func initializeDetailsItemsTableView() {
        let detailsItemsTableView = UITableView()
        detailsItemsTableView.rowHeight = GameDetailsItemViewCell.prefferedHeight
        detailsItemsTableView.register(UINib(nibName: "GameDetailsItemViewCell", bundle: nil), forCellReuseIdentifier: detailsItemCellReuseIdentifier)
        _ = addSafeAutoLayoutSubview(detailsItemsTableView, overrideAnchors: AnchorsContainer(top: topAnchor))
        self.detailsItemsTableView = detailsItemsTableView
        bindGameDetailsItems()
    }

    private func bindGameDetailsItems() {
        bindGameDetailsItemsData()
        bindGameDetailsItemSelected()
    }

    private func bindGameDetailsItemsData() {
        controllerProtocol?.viewModel.gameDetailsItemsObser.bind(to: detailsItemsTableView.rx.items(cellIdentifier: detailsItemCellReuseIdentifier)) { _, model, cell in
            (cell as? GameDetailsItemViewCell)?.gameDetailsItem = model
            }
            .disposed(by: disposeBag)
    }

    private func bindGameDetailsItemSelected() {
        detailsItemsTableView.rx.itemSelected.asDriver().drive(onNext: { [weak self] indexPath in
            guard let self = self else {
                return
            }
            self.goToDetailsItem(atIndexPath: indexPath)
            self.detailsItemsTableView.deselectRow(at: indexPath, animated: true)
        }).disposed(by: disposeBag)
    }

    private func goToDetailsItem(atIndexPath indexPath: IndexPath) {
        guard let controllerProtocol = controllerProtocol, let gameDetailsItem = controllerProtocol.viewModel.gameDetailsItem(forIndexPath: indexPath) else {
            return
        }
        controllerProtocol.goToDetailsItem(gameDetailsItem)
    }

    // MARK: Details views resizing functions
    private func resizeDetailsViews() {
        resizeDetailsHeaderView()
        resizeDetailsFooterView()
    }
    
    private func resizeDetailsHeaderView() {
        detailsHeaderWidthConst.constant = bounds.width
        resizeViewToMatchWidth(detailsHeaderView)
        detailsItemsTableView.tableHeaderView = detailsHeaderView
    }
    
    private func resizeViewToMatchWidth(_ view: UIView) {
        view.setNeedsLayout()
        view.layoutIfNeeded()

        //resize
        let height = view.systemLayoutSizeFitting(CGSize(width: view.bounds.width, height: UIView.layoutFittingCompressedSize.height)).height
        var frame = view.frame
        frame.size.height = height
        view.frame = frame
    }

    func resizeDetailsFooterView() {
        detailsFooterWidthConst.constant = bounds.width
        resizeViewToMatchWidth(detailsFooterView)
        detailsItemsTableView.tableFooterView = detailsFooterView
    }

    func addViewToDetailsFooter(_ view: UIView) {
        _ = detailsFooterView.addAutoLayoutSubview(view)
    }
}
