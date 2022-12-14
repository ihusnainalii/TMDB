//
//  HomeCellView.swift
//  TMDB
//
//  Created by devadmin on 14/12/2022.
//

import UIKit

class HomeCellView: UICollectionViewCell {

    // MARK: - Identifier
    static let identifier = "HomeCellView"
    
    // MARK: - IBOutlets
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var dateLbl: UILabel!
    
    // MARK: - Variables
    var movieCellVM: MovieCellViewModel? {
        didSet {
            guard let movieCellVM = movieCellVM else {
                return
            }
            titleLbl?.text = movieCellVM.movie.value?.title ?? ""
            dateLbl?.text = movieCellVM.movie.value?.releaseDate ?? ""
            if let url = movieCellVM.movie.value?.posterPath {
                movieImage.setImage(url)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
