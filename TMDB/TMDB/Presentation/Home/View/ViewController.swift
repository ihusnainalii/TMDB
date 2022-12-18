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
    let refreshControl = UIRefreshControl()
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
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        guard previousTraitCollection != nil else { return }
        collectionView?.collectionViewLayout.invalidateLayout()
        collectionView.reloadData()
    }
    
    // MARK: - IBActions
    @objc func searchTapped() {
        print("Search Tapped")
        if let view = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController {
            self.navigationController?.pushViewController(view, animated: true)
        }
    }
    
    @objc func refresh() {
        refreshControl.endRefreshing()
        Database.shared.deleteAll(deleteObjClass: Movie.self) { realmResponse in
            switch realmResponse {
            case .success:
                print("Local Movie data deleted")
            case .failure(let error):
                print("Local Movie data not deleted with error: \(error)")
            }
        }
        MonitorNetwork().Connection(observe: false) { connection in
            if let isConnected = connection, isConnected {
                self.viewModel.pagination.accept(Pagination())
                self.viewModel.fetchMovies()
            }
        }
    }
    
    @objc func favoriteTapped() {
        if let view = self.storyboard?.instantiateViewController(withIdentifier: "FavoriteViewController") as? FavoriteViewController {
            view.delegate = self
            self.navigationController?.pushViewController(view, animated: true)
        }
    }
    
    // MARK: - Custom Functions
    func configureGrid() {
        collectionView.updateFLow(5, 5, false)
        collectionView.clearBackground()
        collectionView.clearSideBars()
        
        refreshControl.tintColor = .black
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        collectionView.alwaysBounceVertical = true
    }
    
    private func subscribeRelay() {
        viewModel.movies.observe(on: MainScheduler.instance).subscribe (
            onNext: { data in
                // print(data)
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
                self.showAlert(message)
            }
        }).disposed(by: disposeBag)
    }
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "TMDB", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension ViewController: FavoriteMoviesDelegate {
    func updateMovie(_ movie: Movie) {
        let movies = viewModel.movies.value
        if let index = movies.firstIndex(where: { viewModel in
            viewModel.movie.value?.id == movie.id
        }) {
            movies[index].movie.accept(movie)
        }
        viewModel.movies.accept(movies)
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.movies.value.count - 1 {
            if let pageNumber = viewModel.pagination.value.page, let totalPages = viewModel.pagination.value.totalPages, pageNumber <= totalPages {
                MonitorNetwork().Connection(observe: false) { connection in
                    if let isConnected = connection, isConnected {
                        DispatchQueue.main.async {
                            self.viewModel.fetchMovies()
                        }
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let cellWidth = (width - 5) / 2
        return CGSize(width: cellWidth, height: cellWidth / 0.6)
    }
}
