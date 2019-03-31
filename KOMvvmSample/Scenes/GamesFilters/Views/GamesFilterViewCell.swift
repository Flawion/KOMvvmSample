//
//  GamesFilterViewCell.swift
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

protocol GamesFilterViewCellDelegate: NSObjectProtocol {
    func gamesFilter(viewCell: UITableViewCell, clearFilter: GamesFilterModel)
}

final class GamesFilterViewCell: BaseTableViewCell {
    @IBOutlet weak var nameLabel: CellTitleLabel!
    @IBOutlet weak var selectedOptionsLabel: BaseLabel!
    @IBOutlet weak var clearButton: IconButton!
    @IBOutlet weak var bottomLine: UIView!

    weak var delegate: GamesFilterViewCellDelegate?

    weak var filter: GamesFilterModel? {
        didSet {
            //sets filter data
            nameLabel.text = filter?.filter.localizable
            if let displayValue = filter?.displayValue, !displayValue.isEmpty {
                selectedOptionsLabel.text = displayValue
            } else {
                selectedOptionsLabel.text = "games_filters_undefined_value".localized
            }

            //show/hide clear button for all filter except sorting
            if let filter = filter, filter.filter != .sorting {
                clearButton.isHidden = filter.value.isEmpty
            } else {
                clearButton.isHidden = true
            }
        }
    }

    @IBAction func clearButtonClicked(_ sender: Any) {
        guard let filter = filter else {
            return
        }
        delegate?.gamesFilter(viewCell: self, clearFilter: filter)
    }
}
