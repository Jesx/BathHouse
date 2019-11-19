//
//  ViewController.swift
//  BathHouse
//
//  Created by Jes Yang on 2019/11/19.
//  Copyright © 2019 Jes Yang. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var currentPeople: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getBathHousePeople()
    }
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        getBathHousePeople()
    }
    
    @IBAction func enterBathHouse(_ sender: UIButton) {
        let input = nameTextField.text
        let gender = segmentControl.titleForSegment(at: segmentControl.selectedSegmentIndex)
        
        if (input?.isEmpty)! || input?.trimmingCharacters(in: .whitespaces) == "" {
            let alert = UIAlertController(title: "名稱錯誤", message: "請輸入正確名稱", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            
        } else {

            BathHouseData().sendPeopleToBathHouse(name: input!, gender: gender!) { (response) in
                if response.message == "Enter the bathhouse successfully" {
                    let alert = UIAlertController(title: "歡迎來到皂滑弄人大澡堂", message: "成功進入澡堂", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
                        DispatchQueue.main.async {
                            let storyboard = UIStoryboard(name: "BathHouse", bundle: nil)
                            let bathHouseVC =  storyboard.instantiateViewController(identifier: "BathHouseVC") as! BathHouseViewController
                            
                            bathHouseVC.name = input!
                            self.navigationController?.pushViewController(bathHouseVC, animated: true)
                        }
                    }
                    
                    alert.addAction(okAction)
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil)
                    }
    
                } else if response.message == "The bathhouse is full!!" {
                    
                }
            }
        }
    }
    @IBAction func goBuyBeverage(_ sender: UIButton) {
    }
    
}

extension MainViewController {
    func getBathHousePeople() {
        activityIndicator.isHidden = false
        BathHouseData().getBathHousePeople { (bathHouse) in
            DispatchQueue.main.async {
                self.currentPeople.text = String(bathHouse.currentNumberOfPeople)
                self.activityIndicator.isHidden = true
            }
        }
    }
}
