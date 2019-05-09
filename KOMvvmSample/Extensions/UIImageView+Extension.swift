//
//  UIImageView+Extension.swift
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

import Foundation
import SDWebImage

extension UIImageView {
    public func setImageFade(image: UIImage, duration: TimeInterval = 0.25, renderingMode: UIImage.RenderingMode = UIImage.RenderingMode.automatic, completion: (() -> Void)? = nil) {
        alpha = 0
        UIView.transition(with: self, duration: duration, options: UIView.AnimationOptions.transitionCrossDissolve, animations: { [weak self] () -> Void in
            guard let self = self else {
                return
            }
            self.image = image.withRenderingMode(renderingMode)
            self.alpha = 1
            }, completion: nil)
    }

    public func setImageFade(url: URL, placeholderImage: UIImage? = nil, duration: TimeInterval = 0.25, onlyNotCached: Bool = true, renderingMode: UIImage.RenderingMode = UIImage.RenderingMode.automatic, completion: (() -> Void)? = nil) {
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
