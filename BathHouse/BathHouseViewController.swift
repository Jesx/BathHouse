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
    
    var people = [People]()
    
    var name: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "買飲料", style: .plain, target: self, action: #selector(addTapped))

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicator.isHidden = false
        BathHouseData().getBathHousePeople { (bathHouse) in
            
            self.people = bathHouse.peopleInTheHouse
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.activityIndicator.isHidden = true
            }
        }
    }
    
    @objc func addTapped() {
        let storyboard = UIStoryboard(name: "Beverage", bundle: nil)
        let beverageVC =  storyboard.instantiateViewController(identifier: "BeverageVC") as! BeverageTableViewController
        beverageVC.name = name
        navigationController?.pushViewController(beverageVC, animated: true)
        
    }

}

extension BathHouseViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: BathHouseCollectionViewCell.self), for: indexPath) as! BathHouseCollectionViewCell
        
        
        if people.count - 1 >= indexPath.item {
            print(people[indexPath.row])
            if people[indexPath.item].gender.rawValue == "male" {
                if people[indexPath.item].withDrink == 0 {
                    cell.bathHouseImageView.image = UIImage(named: "Boy")
                } else {
                    cell.bathHouseImageView.image = UIImage(named: "BoywiBeverage")
                }
                
            } else {
                if people[indexPath.item].withDrink == 0 {
                    cell.bathHouseImageView.image = UIImage(named: "Girl")
                } else {
                    cell.bathHouseImageView.image = UIImage(named: "GirlwiBeverage")
                }
            }
        } else {
           cell.bathHouseImageView.image = UIImage(named: "Nobody")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.width / 3 - 10
        
        return CGSize(width: size, height: size)
    }
}
