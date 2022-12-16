//
//  CollectionView+Extension.swift
//  TMDB
//
//  Created by devadmin on 14/12/2022.
//

import Foundation
import UIKit

extension UICollectionView {
    
    func confirm(with delegate: UICollectionViewDelegate) {
        self.delegate = delegate
        self.backgroundColor = .clear
    }
    
    func register(with identifier: String) {
        self.register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
    }
    
    func updateFLow(_ itemSpacing: CGFloat = 5, _ lineSpacing: CGFloat = 5, _ ishorizontal: Bool) {
        let flow = UICollectionViewFlowLayout()
        flow.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        flow.minimumInteritemSpacing = itemSpacing
        flow.minimumLineSpacing = lineSpacing
        flow.scrollDirection = ishorizontal ? .horizontal : .vertical
        
        // Apply flow layout
        self.setCollectionViewLayout(flow, animated: true)
    }
    
    func isScrollEnable(isEnable: Bool) {
        self.isScrollEnabled = isEnable
    }
    
    func clearBackground() {
        self.backgroundColor = .clear
        self.backgroundView = UIView(frame: .zero)
    }
    
    func clearSideBars() {
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
    }
}

extension UITableView {
    
    func update() {
        self.separatorStyle = .singleLine
        self.separatorColor = .lightText
        self.tableFooterView = UIView(frame: .zero)
        self.backgroundColor = .clear
    }
    
    func register(_ identifier: String) {
        self.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    }
}
