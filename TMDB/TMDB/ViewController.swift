//
//  ViewController.swift
//  TMDB
//
//  Created by devadmin on 14/12/2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        let repo = MoviesRepository()
        repo.get(.fetchMovies, [:]) { result in
            
            // Response handling
            switch result {
            case .success(let metaData):
                print(metaData)
            case .failure(let error):
                print("Parser error \(error)")
            }
        }
    }


}

