//
//  UIColor+Resources.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation

extension UIColor {
    struct Theme {
        static var viewControllerBackground: UIColor {
            if #available(iOS 13, *) {
                return UIColor.systemBackground
            }
            return UIColor.white
        }
        
        static var barTint: UIColor {
            if #available(iOS 13, *) {
                return UIColor.label
            }
            return UIColor.black
        }
        
        static var barBackground: UIColor {
            if #available(iOS 13, *) {
                return UIColor.systemBackground
            }
            return UIColor.white
        }

        static var baseLabel: UIColor {
            if #available(iOS 13, *) {
                return UIColor.label
            }
            return UIColor.black
        }
        
        static var baseCellTintColor: UIColor {
            if #available(iOS 13, *) {
                return UIColor.label
            }
            return UIColor.black
        }
        
        static var baseCellBackground: UIColor {
            return UIColor.clear
        }

        static var loadingActivityIndicator: UIColor {
            if #available(iOS 13, *) {
                return UIColor.systemGray
            }
            return UIColor.gray
        }
        
        static var imageViewerLoadingBackground: UIColor {
            if #available(iOS 13, *) {
                return UIColor.systemBackground.withAlphaComponent(0.5)
            }
            return UIColor.white.withAlphaComponent(0.5)
        }
        
        static var confirmButtonBackground: UIColor {
            if #available(iOS 13, *) {
                return UIColor.label
            }
            return UIColor.black
        }
        
        static var confirmButtonTitle: UIColor {
            if #available(iOS 13, *) {
                return UIColor.systemBackground
            }
            return UIColor.white
        }
        
        static var gameImageBackground: UIColor {
            if #available(iOS 13, *) {
                return UIColor.systemGray
            }
            return UIColor.lightGray
        }
        
        static var gamesCollectionBackground: UIColor {
            if #available(iOS 13, *) {
                return UIColor.systemBackground
            }
            return UIColor.white
        }
        
        static var gamesCollectionInfiniteScrollIndicator: UIColor {
            if #available(iOS 13, *) {
                return UIColor.systemGray
            }
            return UIColor.gray
        }
        
        static var selectedBackground: UIColor {
            if #available(iOS 13, *) {
                return UIColor.systemGray3
            }
            return UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 1.0)
        }
        
        static var separatorLine: UIColor {
            if #available(iOS 13, *) {
                return UIColor.systemGray2
            }
            return UIColor.lightGray
        }
    }
}
