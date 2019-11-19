//
//  BeverageTableViewController.swift
//  BathHouse
//
//  Created by 黃士軒 on 2019/11/19.
//  Copyright © 2019 Jes Yang. All rights reserved.
//

import UIKit

class BeverageTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 5
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BeverageCell", for: indexPath) as! BeverageTableViewCell

        return cell
    }

// 跳出來用 pop


}
