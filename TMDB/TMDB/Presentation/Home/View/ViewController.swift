//
//  ViewController.swift
//  TMDB
//
//  Created by devadmin on 14/12/2022.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Variables
    
    // MARK: - Constant
    let disposeBag = DisposeBag()
    lazy var viewModel: MoviesViewModel = {
        let viewModel = MoviesViewModel(MoviesRepository())
        return viewModel
    }()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        /// navigation title
        self.title = "Popular movies"
        
        /// Bind collectionView
        bindGridView()
        configureGrid()
        collectionView.register(with: HomeCellView.identifier)
        collectionView.confirm(with: self)
        
        /// Subscribe Reply
        subscribeRelay()
        configureServiceCallBacks()
        
        /// Feetch data
        viewModel.fetchMovies()
    }
    
    // MARK: - IBActions
    
    // MARK: - Custom Functions
    func configureGrid() {
        collectionView.updateFLow(5, 5, false)
        collectionView.clearBackground()
    }
    
    private func subscribeRelay() {
        viewModel.movies.observe(on: MainScheduler.instance).subscribe (
            onNext: { data in
                print(data)
            }
        ).disposed(by: disposeBag)
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

extension ViewController: UICollectionViewDelegateFlowLayout {
    func bindGridView() {
        viewModel.movies.bind(to: collectionView.rx.items(cellIdentifier: HomeCellView.identifier)) { collectionView, movie, cell in
            if let cell = cell as? HomeCellView {
                cell.movieCellVM = movie
            }
        }.disposed(by: disposeBag)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let cellWidth = (width - 6) / 2
        return CGSize(width: cellWidth, height: cellWidth / 0.6)
    }
}
