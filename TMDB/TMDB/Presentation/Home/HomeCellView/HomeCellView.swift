//
//  HomeCellView.swift
//  TMDB
//
//  Created by devadmin on 14/12/2022.
//

import UIKit
import RxSwift
import RxCocoa

class HomeCellView: UICollectionViewCell {

    // MARK: - Identifier
    static let identifier = "HomeCellView"
    
    // MARK: - IBOutlets
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var blurImg: UIImageView!
    
    // MARK: - Variables
    var clickHandler: (() -> Void)?
    var movieCellVM: MovieCellViewModel? {
        didSet {
            guard let movieCellVM = movieCellVM else {
                return
            }
            
            if let title = movieCellVM.movie.value?.title {
                self.titleLbl?.text = title
            }
            self.dateLbl?.text = movieCellVM.movie.value?.getReleaseDate()
            if let isFavorite = movieCellVM.movie.value?.isFavorite {
                let image = isFavorite ? Utilities.Assets.Favorite : Utilities.Assets.Unfavorite
                favoriteBtn.setImage(image, for: .normal)
            } else {
                favoriteBtn.setImage(Utilities.Assets.Unfavorite, for: .normal)
            }
            if let url = movieCellVM.movie.value?.posterPath {
                self.movieImage.setImage(url)
                self.blurImg.setImage(url)
            }
        }
    }
    
    // MARK: - Constants
    let disposeBag = DisposeBag()
    
    // MARK: - View Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // configure view
        cardView.round(8)
        
        // bind view
        bindView()
    }
    
    func bindView() {
        favoriteBtn.rx.tap
            .`do`(onNext: {
                // Impact
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            }).subscribe(onNext: { [unowned self] in
                guard let completion = self.clickHandler else { return }
                completion()
                setFavorite()
            }).disposed(by: disposeBag)
    }
    
    func watchForClickHandler(completion: @escaping () -> Void) {
        self.clickHandler = completion
    }
    
    func setFavorite() {
        
        // Make favorite
        if let movie = movieCellVM?.movie.value {
            guard let realm = Database.shared.realm() else { return }
            try? realm.write {
                if let isFav = movie.isFavorite {
                    movie.isFavorite = !isFav
                }
            }
            self.movieCellVM?.movie.accept(movie)
        }
        
        // Set image
        if let isFavorite = movieCellVM?.movie.value?.isFavorite {
            let image = isFavorite ? Utilities.Assets.Favorite : Utilities.Assets.Unfavorite
            favoriteBtn.setImage(image, for: .normal)
        }
    }
    
    func removeFavorite() {
        
        // Make favorite
        if let movie = movieCellVM?.movie.value {
            guard let realm = Database.shared.realm() else { return }
            try? realm.write {
                movie.isFavorite = false
            }
            self.movieCellVM?.movie.accept(movie)
        }
        
        // Set image
        if let isFavorite = movieCellVM?.movie.value?.isFavorite {
            let image = isFavorite ? Utilities.Assets.Favorite : Utilities.Assets.Unfavorite
            favoriteBtn.setImage(image, for: .normal)
        }
    }
}

extension UIView {
    func round() {
        self.layer.cornerRadius = self.bounds.height / 2
        self.layer.masksToBounds = true
    }
    
    func round(_ round: CGFloat) {
        self.layer.cornerRadius = round
        self.layer.masksToBounds = true
    }
    
    func round(_ corners: UIRectCorner, radius: CGFloat) {
        if #available(iOS 11.0, *) {
            clipsToBounds = true
            layer.cornerRadius = radius
            layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
        } else {
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
    }
    
    func applyNavBarConstraints(size: (width: CGFloat, height: CGFloat)) {
        let widthConstraint = self.widthAnchor.constraint(equalToConstant: size.width)
        let heightConstraint = self.heightAnchor.constraint(equalToConstant: size.height)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
    }
}
