//
//  FavoriteViewController.swift
//  TMDB
//
//  Created by devadmin on 14/12/2022.
//

import UIKit
import RxSwift
import RxCocoa

class FavoriteViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Variables
    var viewModel: FavoriteMoviesViewModel?
    
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
        
        guard let viewModel = viewModel else {return}
        
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

extension FavoriteViewController: UICollectionViewDelegateFlowLayout {
    func bindGridView() {
        guard let viewModel = viewModel else {return}
        viewModel.movies.bind(to: collectionView.rx.items(cellIdentifier: HomeCellView.identifier, cellType: HomeCellView.self)) { row, movie, cell in
            cell.movieCellVM = movie
            cell.watchForClickHandler {
                print("Favorite tapped")
                viewModel.movies.remove(at: row)
            }
        }.disposed(by: disposeBag)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let cellWidth = (width - 5) / 2
        return CGSize(width: cellWidth, height: cellWidth / 0.6)
    }
}
