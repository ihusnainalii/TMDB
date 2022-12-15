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
    
    lazy var rightBarItems: Array = { () -> [UIBarButtonItem] in
        
        // Button Configuration
        var searchBtnConfig = UIButton.Configuration.filled()
        searchBtnConfig.image = UIImage(systemName: "magnifyingglass")
        searchBtnConfig.imagePlacement = .trailing
        searchBtnConfig.imagePadding = 5
        searchBtnConfig.buttonSize = .mini
        let searchBtn = UIButton(configuration: searchBtnConfig, primaryAction: nil)
        
        // Button properties
        searchBtn.imageView?.contentMode = .scaleAspectFit
        searchBtn.tintColor = .white
        searchBtn.addTarget(self, action: #selector(searchTapped), for: .touchUpInside)
        
        // Create Custom View
        let searchBtnView = UIBarButtonItem(customView: searchBtn)
        
        return [searchBtnView]
    }()
    
    lazy var leftBarItems: Array = { () -> [UIBarButtonItem] in
        // Button Configuration
        var favBtnConfig = UIButton.Configuration.filled()
        favBtnConfig.image = UIImage(systemName: "heart.fill")
        favBtnConfig.imagePlacement = .trailing
        favBtnConfig.imagePadding = 5
        favBtnConfig.buttonSize = .mini
        let favBtn = UIButton(configuration: favBtnConfig, primaryAction: nil)
        
        // Button properties
        favBtn.imageView?.contentMode = .scaleAspectFit
        favBtn.tintColor = .white
        favBtn.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
        
        // Create Custom View
        let favBtnView = UIBarButtonItem(customView: favBtn)
        return [favBtnView]
    }()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        /// navigation title
        self.title = "Popular movies"
        self.navigationItem.setRightBarButtonItems(rightBarItems, animated: true)
        self.navigationItem.setLeftBarButtonItems(leftBarItems, animated: true)
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        print("View appear")
    }
    
    // MARK: - IBActions
    @objc func searchTapped() {
        print("Search Tapped")
    }
    
    @objc func favoriteTapped() {
        viewModel.fetchFavorites()
    }
    
    // MARK: - Custom Functions
    func configureGrid() {
        collectionView.updateFLow(5, 5, false)
        collectionView.clearBackground()
        collectionView.clearSideBars()
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
        
        // success
        viewModel.isSuccess
            .asObservable()
            .filter { $0 }.bind { success in
                if success {
                    if let view = self.storyboard?.instantiateViewController(withIdentifier: "FavoriteViewController") as? FavoriteViewController {
                        view.viewModel = FavoriteMoviesViewModel(MoviesRepository(), self.viewModel.favorites.value)
                        self.navigationController?.pushViewController(view, animated: true)
                    }
                }
            }.disposed(by: disposeBag)
        
        viewModel.message.drive(onNext: {(_message) in
            if let message = _message {
                print(message)
            }
        }).disposed(by: disposeBag)
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func bindGridView() {
        viewModel.movies.bind(to: collectionView.rx.items(cellIdentifier: HomeCellView.identifier, cellType: HomeCellView.self)) { collectionView, movie, cell in
            cell.movieCellVM = movie
            cell.watchForClickHandler {
                print("Favorite tapped")
            }
        }.disposed(by: disposeBag)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let cellWidth = (width - 5) / 2
        return CGSize(width: cellWidth, height: cellWidth / 0.6)
    }
}
