//
//  AdvertisingViewController.swift
//  Preschool Math Game
//
//  Created by Gago Mkrtchyan on 24.09.21.
//

import UIKit

enum CellTypes {
    case firsts
    case second
    case third
}

class AdvertisingViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
        
    private var cellType: [CellTypes] = []
    private var section = 0
    private var row = 0
    
    private var lastContentOffset: CGFloat = 0
    
    override var prefersHomeIndicatorAutoHidden: Bool { return false }
    
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return UIRectEdge.bottom
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if UIDevice.current.userInterfaceIdiom != .pad {
            if UIScreen.main.bounds.size.width > 667 {
                collectionView.contentInset.left = -50
                collectionView.contentInset.top = 21.5
            }
        }
                
        collectionView.register(UINib(nibName: "AdvertisingCollectionCell", bundle: nil), forCellWithReuseIdentifier: "AdvertisingCollectionCell")
        collectionView.register(UINib(nibName: "Advertising2CollectionCell", bundle: nil), forCellWithReuseIdentifier: "Advertising2CollectionCell")
        collectionView.register(UINib(nibName: "PurchasingCollectionCell", bundle: nil), forCellWithReuseIdentifier: "PurchasingCollectionCell")
        
    }
}

extension AdvertisingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        cellType = []
        cellType.append(.firsts)
        cellType.append(.second)
        cellType.append(.third)
        
        return cellType.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                
        switch cellType[indexPath.section] {
        case .firsts:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdvertisingCollectionCell", for: indexPath) as! AdvertisingCollectionCell
            cell.delegate = self
            
            return cell
            
        case .second:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Advertising2CollectionCell", for: indexPath) as! Advertising2CollectionCell
            cell.delegate = self
            
            return cell
            
        case .third:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PurchasingCollectionCell", for: indexPath) as! PurchasingCollectionCell
            cell.delegate = self
            
            return cell
        }
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                
        let width = collectionView.frame.size.width
        let height = collectionView.frame.size.height
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        section = indexPath.section
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if (self.lastContentOffset > scrollView.contentOffset.x) {
            row -= 1
            
        } else if (self.lastContentOffset < scrollView.contentOffset.x) {
            row += 1
        }
        
        self.lastContentOffset = scrollView.contentOffset.x
        
        if section == 2 && row == 2 {
            collectionView.isScrollEnabled = false
        }
    }
}

extension AdvertisingViewController: AdvertisingCollectionCellDelaget {
    func goToPurchase() {
        
        collectionView.isPagingEnabled = false
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 2), at: .right, animated: false)
        collectionView.isScrollEnabled = false
    }
}

extension AdvertisingViewController: Advertising2CollectionCellDelegate {
    func goToPurchaseing() {
        
        collectionView.isPagingEnabled = false
        collectionView?.scrollToItem(at: IndexPath(row: 0, section: 2), at: .right, animated: false)
        collectionView.isScrollEnabled = false
    }
}

extension AdvertisingViewController: PurchasingCollectionCellDelegate {
    func push() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BasePageController") as! BasePageController
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
