//
//  BathHouseViewController.swift
//  BathHouse
//
//  Created by Jes Yang on 2019/11/19.
//  Copyright © 2019 Jes Yang. All rights reserved.
//

import UIKit

class BathHouseViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        activityIndicator.isHidden = false
        BathHouseData().getBathHousePeople { (bathHouse) in
            DispatchQueue.main.async {
                self.activityIndicator.isHidden = true
            }
        }

    }

}

extension BathHouseViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: BathHouseCollectionViewCell.self), for: indexPath) as! BathHouseCollectionViewCell
        
        cell.bathHouseImageView.image = UIImage(named: "BoywiBeverage")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.width / 3 - 12
        
        return CGSize(width: size, height: size)
    }
}
