//
//  ViewController.swift
//  ShoppingList
//
//  Created by Fuat Bolat on 20.10.2024.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
    }
    
    @objc func addItem() {
        performSegue(withIdentifier: "toDetailsVc", sender: self)
    }


}

