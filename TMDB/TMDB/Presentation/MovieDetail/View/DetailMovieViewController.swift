//
//  DetailMovieViewController.swift
//  TMDB
//
//  Created by devadmin on 16/12/2022.
//

import UIKit
import RxSwift
import RxCocoa

class DetailMovieViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var viewsLbl: UILabel!
    @IBOutlet weak var decriptionTV: UITextView!
    @IBOutlet weak var coverImg: UIImageView!
    @IBOutlet weak var posterImg: UIImageView!
    @IBOutlet weak var scrollHeight: NSLayoutConstraint!
    @IBOutlet weak var isAdultIcon: UIImageView!
    
    // MARK: - Variables
    var delegate: FavoriteMoviesDelegate?
    
    // MARK: - Constant
    let disposeBag = DisposeBag()
    var viewModel: MovieDetailViewModel?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bindView()
        updateDetails()
        configureServiceCallBacks()
    }
    
    func updateDetails() {
        if let title = viewModel?.movie.value?.title {
            self.titleLbl?.text = title
        }
        if let isAdult = viewModel?.movie.value?.adult {
            self.isAdultIcon.isHidden = !isAdult
        }
        
        if let overview = viewModel?.movie.value?.overview {
            self.decriptionTV?.text = overview
        }
        if let voteCount = viewModel?.movie.value?.voteCount, let voteAverage = viewModel?.movie.value?.voteAverage {
            self.viewsLbl?.text = "Votes: \(voteCount) (\(voteAverage))"
        }
        if let isFavorite = viewModel?.movie.value?.isFavorite {
            let image = isFavorite ? Utilities.Assets.Favorite : Utilities.Assets.Unfavorite
            favoriteBtn.setImage(image, for: .normal)
        } else {
            favoriteBtn.setImage(Utilities.Assets.Unfavorite, for: .normal)
        }
        if let url = viewModel?.movie.value?.posterPath {
            self.posterImg.setImage(url)
        }
        if let url = viewModel?.movie.value?.backdropPath {
            self.coverImg.setImage(url, isHighRes: true)
        }
    }

    func bindView() {
        favoriteBtn.rx.tap
            .`do`(onNext: {
                // Impact
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            }).subscribe(onNext: { [unowned self] in
                viewModel?.updateFavorite()
            }).disposed(by: disposeBag)
    }
    
    /// Displays HUD from API called to main View , a succes observable  for API here we perform action based on success/failure
    /// Message from response or set in viewModel
    private func configureServiceCallBacks() {
        
        // success
        viewModel?.isSuccess
            .asObservable()
            .filter { $0 }.bind { success in
                
                // Set image
                if let isFavorite = self.viewModel?.movie.value?.isFavorite {
                    let image = isFavorite ? Utilities.Assets.Favorite : Utilities.Assets.Unfavorite
                    self.favoriteBtn.setImage(image, for: .normal)
                }
                
                // Favorite delegate
                if let movieData =  self.viewModel?.movie.value {
                    self.delegate?.updateMovie(movieData)
                }
            }.disposed(by: disposeBag)
    }
}
