//
//  ImageViewerView.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit

final class ImageViewerView: UIView {
    // MARK: Variables
    private weak var controllerProtocol: ImageViewerViewControllerProtocol?
    
    private weak var scrollView: UIScrollView!
    private weak var imageView: UIImageView!
    private weak var imageLeftConst: NSLayoutConstraint!
    private weak var imageTopConst: NSLayoutConstraint!
    private var isPhotoModeOn: Bool = false
    
    private var lastScrollViewSize: CGRect = CGRect.zero
    private var imageToDocumentSizeRatio: CGFloat = 0
    
    // MARK: Initialization
    init(controllerProtocol: ImageViewerViewControllerProtocol) {
        self.controllerProtocol = controllerProtocol
        super.init(frame: CGRect.zero)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    deinit {
        imageView.sd_cancelCurrentImageLoad()
    }
    
    private func initialize() {
        initializeScrollView()
        initializeImageView()
        initializeZoomTapGesture()
    }

    private func initializeScrollView() {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.contentInsetAdjustmentBehavior = .never
        _ = addAutoLayoutSubview(scrollView)
        self.scrollView = scrollView
    }

    private func initializeImageView() {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        let constraints = scrollView.addAutoLayoutSubview(imageView)
        imageLeftConst = constraints.left
        imageTopConst = constraints.top
        self.imageView = imageView

        refreshImageData()
    }

    func refreshImageData() {
        guard let controllerProtocol = controllerProtocol, let imageUrl = controllerProtocol.viewModel.image.original else {
            return
        }
        controllerProtocol.viewModel.change(dataActionState: .loading)
        imageView.sd_setImage(with: imageUrl) { [weak self] (image, _, _, _) in
            guard let self = self, let controllerProtocol = self.controllerProtocol else {
                return
            }
            guard image != nil else {
                controllerProtocol.viewModel.change(dataActionState: .error)
                return
            }
            controllerProtocol.viewModel.change(dataActionState: .none)
            self.scrollView.layoutIfNeeded()
            self.refreshImage()
        }
    }

    private func initializeZoomTapGesture() {
        let zoomTapGesture = UITapGestureRecognizer(target: self, action: #selector(zoomTapGestureTap(gesture:)))
        zoomTapGesture.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(zoomTapGesture)
    }

    @objc private func zoomTapGestureTap(gesture: UITapGestureRecognizer) {
        guard imageToDocumentSizeRatio > 0, scrollView.zoomScale != imageToDocumentSizeRatio  else {
            return
        }
        scrollView.setZoomScale(imageToDocumentSizeRatio, animated: true)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        refreshImageIfBoundsChnaged()
    }
    
    // MARK: Refresh image function
    private func refreshImageIfBoundsChnaged() {
        guard scrollView.bounds.size != lastScrollViewSize.size else {
            return
        }
        refreshImage()
    }
    
    private func refreshImage() {
        refreshImageZoomScale()
        refreshImagePosition()
        refreshPhotoMode()
        lastScrollViewSize =  scrollView.bounds
    }
    
    private func refreshImageZoomScale() {
        guard scrollView.bounds.width > 0 && imageView.bounds.width > 0 else {
            return
        }
        imageToDocumentSizeRatio = scrollView.bounds.width / imageView.bounds.width
        scrollView.minimumZoomScale = min(1, imageToDocumentSizeRatio)
        scrollView.maximumZoomScale = 1
        scrollView.zoomScale = scrollView.minimumZoomScale
    }
    
    private func refreshImagePosition() {
        guard scrollView.bounds.width > 0 && imageView.bounds.width > 0 else {
            return
        }
        
        var heightOffset = (scrollView.bounds.height / 2) - ((imageView.bounds.size.height * scrollView.zoomScale) / 2)
        heightOffset = max(0, heightOffset)
        imageTopConst.constant = heightOffset
        
        var widthOffset = (scrollView.bounds.width / 2) - ((imageView.bounds.size.width * scrollView.zoomScale) / 2)
        widthOffset = max(0, widthOffset)
        imageLeftConst.constant = widthOffset
        scrollView.layoutIfNeeded()
    }

    // MARK: Photo mode functions
    private func refreshPhotoMode() {
        guard imageToDocumentSizeRatio > 0 else {
            return
        }
        scrollView.zoomScale <= imageToDocumentSizeRatio ? turnOffPhotoMode() : turnOnPhotoMode()
    }

    private func turnOnPhotoMode() {
        guard !isPhotoModeOn else {
            return
        }
        isPhotoModeOn = true
        UIView.animate(withDuration: 0.4, animations: { [weak self] in
            guard let self = self else {
                return
            }
            self.backgroundColor = UIColor.black
        })
        controllerProtocol?.turnOnPhotoMode()
    }

    private func turnOffPhotoMode() {
        guard isPhotoModeOn else {
            return
        }
        isPhotoModeOn = false
        UIView.animate(withDuration: 0.4, animations: { [weak self] in
            guard let self = self else {
                return
            }
            self.backgroundColor = UIColor.Theme.viewControllerBackground
        })
        controllerProtocol?.turnOffPhotoMode()
    }
}

// MARK: - UIScrollViewDelegate
extension ImageViewerView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        refreshImagePosition()
        refreshPhotoMode()
    }
}
