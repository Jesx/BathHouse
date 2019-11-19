//
//  BeverageTableViewController.swift
//  BathHouse
//
//  Created by 黃士軒 on 2019/11/19.
//  Copyright © 2019 Jes Yang. All rights reserved.
//

import UIKit

class BeverageTableViewController: UITableViewController {
    
    var beverageItems: BeverageItems?
    let activityIndicatorView = UIActivityIndicatorView(style: .large)
    
    var name: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getBerverageData()
        tableView.tableFooterView = UIView()
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.center = view.center
        activityIndicatorView.startAnimating()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return beverageItems?.data.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BeverageCell", for: indexPath) as! BeverageTableViewCell
        
        cell.beverageNameLabel.text = beverageItems?.data[indexPath.item].drink_name
        cell.beverageImage.image = UIImage(named: beverageItems?.data[indexPath.item].drink_name ?? "")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "要買 \(beverageItems!.data[indexPath.item].drink_name) 嗎？", message: "", preferredStyle: .alert)
        
        let alreadyBuyAlert = UIAlertController(title: "買好啦", message: "", preferredStyle: .alert)
        
        let buyAction = UIAlertAction(title: "買了", style: .default) { (UIAlertAction) in
            
            let passingData = BuyDrinkInformation(user_name: self.name, drink_id: (self.beverageItems?.data[indexPath.item].id)!)
            
            guard let uploadData = try? JSONEncoder().encode(passingData) else {
                return
            }
            let url = URL(string: "https://1ed4813f.ngrok.io/api/drinks")!

            var request = URLRequest(url: url)
            request.httpMethod = "Post"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let task = URLSession.shared.uploadTask(with: request, from: uploadData) { data, response, error in

                if let error = error {
                    print ("error: \(error)")
                    return
                }

                guard let response = response as? HTTPURLResponse,
                    (200...299).contains(response.statusCode) else {
                        print ("server error")
                        return
                }

                if let mimeType = response.mimeType,
                    mimeType == "application/json",
                    let data = data,
                    let dataString = String(data: data, encoding: .utf8) {
                    print (dataString)
                }
            }
            task.resume()
            
            self.present(alreadyBuyAlert, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "不要", style: .cancel, handler: nil)
        let goToBathAction = UIAlertAction(title: "洗澡去～", style: .default) { (UIAlertAction) in
            self.navigationController?.popViewController(animated: true)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(buyAction)
        alreadyBuyAlert.addAction(goToBathAction)
        present(alert, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension BeverageTableViewController {
    
    func getBerverageData() {
        
        if let url = URL(string: "https://1ed4813f.ngrok.io/api/drinks") {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("error: \(error.localizedDescription)")
                }
                
                if let response = response as? HTTPURLResponse {
                    print("status code: \(response.statusCode)")
                }
                
                guard let data = data else { return }
                do {
                    let receivedData = try JSONDecoder().decode(BeverageItems.self, from: data)
                    self.beverageItems = receivedData
                    
                    DispatchQueue.main.async {
                        self.activityIndicatorView.removeFromSuperview()
                        self.tableView.reloadData()
                    }
                    
                } catch {
                    print(error.localizedDescription)
                    let string = String(data: data, encoding: .utf8)
                    print(string!)
                }
            }.resume()
        }
    }
}
