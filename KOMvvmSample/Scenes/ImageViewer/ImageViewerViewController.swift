//
//  ImageViewerViewController.swift
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

final class ImageViewerViewController: BaseViewController {
    private weak var imageViewerView: ImageViewerView!
    
    let viewModel: ImageViewerViewModel
    
    // MARK: Initialization
    init(viewModel: ImageViewerViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let imageViewerView = ImageViewerView(controllerProtocol: self)
        view = imageViewerView
        self.imageViewerView = imageViewerView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    private func initialize() {
        initializeView()
        bindActions(toViewModel: viewModel)
        addRefreshButtonHandler()
    }
    
    private func initializeView() {
        prepareNavigationBar(withTitle: "image_viewer_bar_title".localized)
    }
    private func addRefreshButtonHandler() {
        (errorView as? ErrorView)?.refreshButtonClicked.asDriver().drive(onNext: { [weak self] in
            self?.imageViewerView.refreshImageData()
        }).disposed(by: disposeBag)
    }
    
    override func initializeLoadingView() -> BaseStateView {
        let imageViewerLoadingView = ImageViewerLoadingView()
        _ = view.addAutoLayoutSubview(imageViewerLoadingView)
        guard let imageUrl = viewModel.image.mediumUrl else {
            return imageViewerLoadingView
        }
        imageViewerLoadingView.placeholderImageView.setImageFade(url: imageUrl)
        return imageViewerLoadingView
    }
}

// MARK: - ImageViewerViewControllerProtocol
extension ImageViewerViewController: ImageViewerViewControllerProtocol {
    func turnOnPhotoMode() {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func turnOffPhotoMode() {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
