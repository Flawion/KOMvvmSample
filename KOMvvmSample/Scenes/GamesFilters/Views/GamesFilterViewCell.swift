//
//  GamesFilterViewCell.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

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
            refreshFilter()
        }
    }

    private func refreshFilter() {
        refreshDisplayTexts()
        refreshClearButtonVisibility()
    }
    
    private func refreshDisplayTexts() {
        nameLabel.text = filter?.filter.localizable
        if let displayValue = filter?.displayValue, !displayValue.isEmpty {
            selectedOptionsLabel.text = displayValue
        } else {
            selectedOptionsLabel.text = "games_filters_undefined_value".localized
        }
    }
    
    private func refreshClearButtonVisibility() {
        guard let filter = filter, filter.filter != .sorting  else {
            clearButton.isHidden = true
            return
        }
        clearButton.isHidden = filter.value.isEmpty
    }
    
    @IBAction func clearButtonClicked(_ sender: Any) {
        guard let filter = filter else {
            return
        }
        delegate?.gamesFilter(viewCell: self, clearFilter: filter)
    }
}
