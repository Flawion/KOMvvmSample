//
//  GamesFilterModel.swift
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

final class GamesFilterModel {
    // MARK: Variables
    //public
    var filter: GamesFilters
    var value: String
    var displayValue: String?

    // MARK: Functions
    init(filter: GamesFilters, value: String) {
        self.filter = filter
        self.value = value
    }

    func getSortingOptionsFromValue() -> (option: GamesSortingOptions, direction: GamesSortingDirections)? {
        let sortingOptions = value.split(separator: ":")
        guard sortingOptions.count == 2, let sortingOption = GamesSortingOptions(rawValue: String(sortingOptions[0])), let directionOption = GamesSortingDirections(rawValue: String(sortingOptions[1])) else {
            return nil
        }
        return (sortingOption, directionOption)
    }
}
