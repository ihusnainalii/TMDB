//
//  FavoriteViewController.swift
//  TMDB
//
//  Created by devadmin on 14/12/2022.
//

import UIKit
import RxSwift
import RxCocoa

protocol FavoriteMoviesDelegate {
    func updateMovie(_ movie: Movie)
}

class FavoriteViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Variables
    var delegate: FavoriteMoviesDelegate?
    lazy var viewModel: FavoriteMoviesViewModel = {
        let viewModel = FavoriteMoviesViewModel(MoviesRepository())
        return viewModel
    }()
    
    // MARK: - Constant
    let disposeBag = DisposeBag()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        /// navigation title
        self.title = "Favorite movies"
        
        /// Bind collectionView
        bindGridView()
        configureGrid()
        collectionView.register(with: HomeCellView.identifier)
        collectionView.confirm(with: self)
        
        /// Subscribe Reply
        configureServiceCallBacks()
        
        // get data
        viewModel.fetchFavorites()
    }
    
    // MARK: - IBActions
    
    // MARK: - Custom Functions
    func configureGrid() {
        collectionView.updateFLow(5, 5, false)
        collectionView.clearBackground()
        collectionView.clearSideBars()
    }
    
    /// Displays HUD from API called to main View , a succes observable  for API here we perform action based on success/failure
    /// Message from response or set in viewModel
    private func configureServiceCallBacks() {
        
        // loading
        viewModel.isLoading
            .bind(to: self.view.rx.isShowHUD)
            .disposed(by: disposeBag)
        
        viewModel.message.drive(onNext: {(_message) in
            if let message = _message {
                print(message)
            }
        }).disposed(by: disposeBag)
    }
}

extension FavoriteViewController: FavoriteMoviesDelegate {
    func updateMovie(_ movie: Movie) {
        let movies = viewModel.movies.value
        if let index = movies.firstIndex(where: { movieCellViewModel in
            if let movieCellViewModel = movieCellViewModel.movie.value, let id = movie.id {
                return movieCellViewModel.id == id
            } else {
                return false
            }
        }) {
            self.viewModel.movies.remove(at: index)
            self.delegate?.updateMovie(movie)
        }
    }
}

extension FavoriteViewController: UICollectionViewDelegateFlowLayout {
    func bindGridView() {
        viewModel.movies.bind(to: collectionView.rx.items(cellIdentifier: HomeCellView.identifier, cellType: HomeCellView.self)) { row, movie, cell in
            cell.movieCellVM = movie
            cell.watchForClickHandler {
                print("Favorite tapped")
                self.viewModel.movies.remove(at: row)
                if let movieData =  cell.movieCellVM?.movie.value {
                    self.delegate?.updateMovie(movieData)
                }
            }
        }.disposed(by: disposeBag)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if let view = self.storyboard?.instantiateViewController(withIdentifier: "DetailMovieViewController") as? DetailMovieViewController {
            view.delegate = self
            if let movie = self.viewModel.movies.value[indexPath.row].movie.value {
                view.viewModel = MovieDetailViewModel(movie)
            }
            self.navigationController?.pushViewController(view, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let cellWidth = (width - 5) / 2
        return CGSize(width: cellWidth, height: cellWidth / 0.6)
    }
}
