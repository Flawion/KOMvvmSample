//
//  UIFont+Resources.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation

extension UIFont {
    struct Theme {
        static var baseLabel: UIFont {
            return defaultFont(forSize: 15, weight: .regular)
        }

        static var subtitleLabel: UIFont {
            return defaultFont(forSize: 15, weight: .medium)
        }

        static var barTitleLabel: UIFont {
            return defaultFont(forSize: 17, weight: .bold)
        }

        static var confirmButton: UIFont {
            return defaultFont(forSize: 17, weight: .bold)
        }

        static var gameDetailsHeaderReleaseDateLabel: UIFont {
            return defaultFont(forSize: 15, weight: .medium)
        }

        static var cellTitle: UIFont {
            return defaultFont(forSize: 17, weight: .medium)
        }

        static var cellSmallTitle: UIFont {
            return defaultFont(forSize: 14, weight: .medium)
        }

        static func defaultFont(forSize size: CGFloat = 15, weight: UIFont.Weight = .regular) -> UIFont {
            return UIFont.systemFont(ofSize: size, weight: weight)
        }
    }
}
