//
//  UIimage+Exteension.swift
//  TMDB
//
//  Created by devadmin on 14/12/2022.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    
    func setImage(_ image: UIImage?, animated: Bool = true) {
        let duration = animated ? 0.3 : 0.0
        UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve, animations: {
            self.image = image
        }, completion: nil)
    }
    
    func setImage(_ url: String) {
        self.kf.indicatorType = .activity
        let pathString = AppConfiguration().imageBasePath + url
        self.kf.setImage(with: URL(string: pathString), placeholder: Utilities.Assets.Placeholderimg)
    }
    
    func ofColor(_ color: UIColor) {
        self.image = self.image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }
}
