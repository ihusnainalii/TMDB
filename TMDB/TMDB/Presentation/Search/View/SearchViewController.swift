//
//  SearchViewController.swift
//  TMDB
//
//  Created by devadmin on 16/12/2022.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noMovieLBL: UILabel!
    
    // MARK: - Variables
    
    // MARK: - Constant
    let disposeBag = DisposeBag()
    lazy var viewModel: SearchViewModel = {
        let viewModel = SearchViewModel(SearchRepository())
        return viewModel
    }()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // Navigation
        self.title = "Search Movies"
        
        // Configure search
        searchBar.delegate = self
        searchBar.placeholder = "Search movies..."
        
        /// Bind collectionView
        tableView.register(SearchListView.identifier)
        collectionView.register(with: HomeCellView.identifier)
        collectionView.confirm(with: self)
        bindGridView()
        bindTableView()
        configureGrid()
        tableView.update()
        tableView.delegate = self
        
        /// Subscribe Reply
        configureServiceCallBacks()
        
        // get suggestions
        viewModel.getSuggestions()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        guard previousTraitCollection != nil else { return }
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: - IBActions
    
    // MARK: - Custom Functions
    private func subscribeRelay() {
        viewModel.movies.observe(on: MainScheduler.instance).subscribe (
            onNext: { data in
                self.noMovieLBL.isHidden = !data.isEmpty
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
    
    func configureGrid() {
        collectionView.updateFLow(5, 5, false)
        collectionView.clearBackground()
        collectionView.clearSideBars()
    }
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "TMDB", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Query: \(searchText)")
        
        viewModel.pagination.accept(Pagination())
        viewModel.movies.removeAll()
        noMovieLBL.isHidden = true
        
        if searchText.isEmpty {
            searchBar.text = ""
            collectionView.isHidden = true
            tableView.isHidden = false
            viewModel.getSuggestions()
            viewModel.query.accept("")
        } else {
            viewModel.query.accept(searchText)
            viewModel.searchMovies()
            collectionView.isHidden = false
            tableView.isHidden = true
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchMovies()
        collectionView.isHidden = false
        tableView.isHidden = true
        searchBar.resignFirstResponder()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        tableView.isHidden = false
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tableView.isHidden = true
        collectionView.isHidden = true
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout, UITableViewDelegate {
    func bindGridView() {
        viewModel.movies.bind(to: collectionView.rx.items(cellIdentifier: HomeCellView.identifier, cellType: HomeCellView.self)) { row, movie, cell in
            cell.movieCellVM = movie
            cell.watchForClickHandler {
                print("Favorite tapped")
            }
        }.disposed(by: disposeBag)
    }
    
    func bindTableView() {
        viewModel.suggestion.bind(to: tableView.rx.items(cellIdentifier: SearchListView.identifier, cellType: SearchListView.self)) { (row, suggestion, cell) in
            cell.suggestionCellVM = suggestion
        }.disposed(by: disposeBag)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let keyword = viewModel.suggestion.value[indexPath.row].suggestion.value?.keyword {
            viewModel.pagination.accept(Pagination())
            viewModel.movies.removeAll()
            searchBar.text = keyword
            viewModel.query.accept(keyword)
            viewModel.searchMovies()
            collectionView.isHidden = false
            tableView.isHidden = true
            searchBar.resignFirstResponder()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Search History"
        label.font = UIFont.systemFont(ofSize: 16)
        label.backgroundColor = .white
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.movies.value.count - 1 {
            if let pageNumber = viewModel.pagination.value.page, let totalPages = viewModel.pagination.value.totalPages, pageNumber <= totalPages {
                MonitorNetwork().Connection(observe: false) { connection in
                    if let isConnected = connection, isConnected {
                        DispatchQueue.main.async {
                            self.viewModel.searchMovies()
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
