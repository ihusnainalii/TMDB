//
//  SearchListView.swift
//  TMDB
//
//  Created by devadmin on 16/12/2022.
//

import UIKit

class SearchListView: UITableViewCell {

    // MARK: - Identifier
    static let identifier = "SearchListView"
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleLbl: UILabel!
    
    // MARK: - Variables
    var suggestionCellVM: SearchListViewModel? {
        didSet {
            guard let suggestionCellVM = suggestionCellVM else {
                return
            }
            if let title = suggestionCellVM.suggestion.value?.keyword {
                self.titleLbl?.text = title
            }
        }
    }
    
    // MARK: - Constants
    
    // MARK: - View Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
