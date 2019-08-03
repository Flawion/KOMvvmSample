//
//  UIColor+Resources.swift
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

extension UIColor {
    struct Theme {
        static var viewControllerBackground: UIColor {
            return UIColor.white
        }
        
        static var barTint: UIColor {
            return UIColor.black
        }
        
        static var barBackground: UIColor {
            return UIColor.white
        }

        static var baseLabel: UIColor {
            return UIColor.black
        }

        static var loadingActivityIndicator: UIColor {
            return UIColor.gray
        }
        
        static var imageViewerLoadingBackground: UIColor {
            return UIColor.white.withAlphaComponent(0.5)
        }
        
        static var confirmButtonBackground: UIColor {
            return UIColor.black
        }
        
        static var confirmButtonTitle: UIColor {
            return UIColor.white
        }
        
        static var gameImageBackground: UIColor {
            return UIColor.lightGray
        }
        
        static var gamesCollectionBackground: UIColor {
            return UIColor.white
        }
        
        static var selectedBackground: UIColor {
            return UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 1.0)
        }
        
        static var separatorLine: UIColor {
            return UIColor.lightGray
        }
    }
}
