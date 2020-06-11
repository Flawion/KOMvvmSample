//
//  UIImageView+Extension.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation
import SDWebImage

extension UIImageView {
    func setImageFade(image: UIImage, duration: TimeInterval = 0.25, renderingMode: UIImage.RenderingMode = UIImage.RenderingMode.automatic, completion: (() -> Void)? = nil) {
        alpha = 0
        UIView.transition(with: self, duration: duration, options: UIView.AnimationOptions.transitionCrossDissolve, animations: { [weak self] () -> Void in
            guard let self = self else {
                return
            }
            self.image = image.withRenderingMode(renderingMode)
            self.alpha = 1
            }, completion: nil)
    }

    func setImageFade(url: URL, placeholderImage: UIImage? = nil, duration: TimeInterval = 0.25, onlyNotCached: Bool = true, renderingMode: UIImage.RenderingMode = UIImage.RenderingMode.automatic, completion: (() -> Void)? = nil) {
        self.sd_setImage(with: url, placeholderImage: placeholderImage, options: [], completed: { [weak self] (image, _, cacheType, _) -> Void in
            self?.setImageFade(image: image, cacheType: cacheType, placeholderImage: placeholderImage, duration: duration, onlyNotCached: onlyNotCached, renderingMode: renderingMode, completion: completion)
        })
    }

    private func setImageFade(image: UIImage?, cacheType: SDImageCacheType, placeholderImage: UIImage? = nil, duration: TimeInterval = 0.25, onlyNotCached: Bool = true, renderingMode: UIImage.RenderingMode = UIImage.RenderingMode.automatic, completion: (() -> Void)? = nil) {
        defer {
            completion?()
        }
        guard let downloadedImage = image else {
            self.image = placeholderImage
            return
        }
        if cacheType == .none || !onlyNotCached {
            setImageFade(image: downloadedImage, duration: duration, renderingMode: renderingMode, completion: completion)

        } else if renderingMode != UIImage.RenderingMode.automatic {
            self.image = downloadedImage.withRenderingMode(renderingMode)
        }
    }
}
