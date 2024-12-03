//
//  ViewController.swift
//  ShoppingList
//
//  Created by Fuat Bolat on 20.10.2024.
//

import UIKit
import CoreData

class ViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var secilenUrunName = ""
    var secilenIdNumber : UUID?
    
    var nameArr = [String]()
    var idArr = [UUID]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        //
        getData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver( self, selector: #selector (getData), name: NSNotification.Name(rawValue:"getShopping"), object: nil)
        
    }
    @objc func getData() {
        nameArr.removeAll(keepingCapacity: false)
        idArr.removeAll(keepingCapacity: false)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        //
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Shopping")
       
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            
            let content = try context.fetch(fetchRequest)
            if content.count > 0{
                for i in content as! [NSManagedObject]{
                    if let name = i.value(forKey: "name") as? String{
                        nameArr.append(name)
                    }
                    if let id = i.value(forKey: "id") as? UUID{
                        idArr.append(id)
                    }
                    tableView.reloadData()
                }
                
            }
            
           
        }
        catch{
            print("errorwihle fetching data")
        }
        
    }
    
    @objc func addItem() {
        secilenUrunName = ""
        performSegue(withIdentifier: "toDetailsVc", sender: self)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = nameArr[indexPath.row]
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVc"{
            let destinationVC = segue.destination as! DetailsViewController
            destinationVC.secilenUrun =  secilenUrunName
            destinationVC.secilenId = secilenIdNumber
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        secilenUrunName = nameArr[indexPath.row]
        secilenIdNumber = idArr[indexPath.row]
        performSegue(withIdentifier: "toDetailsVc", sender: self)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            if let uuidString = secilenIdNumber?.uuidString{
                
            
            let apDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = apDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Shopping")
                fetchRequest.predicate = NSPredicate(format: "id = %@",  uuidString)
            fetchRequest.returnsObjectsAsFaults = false
            
                
                
                do
                {
                     let sonuclar = try context.fetch(fetchRequest)
                    for sonuc in sonuclar as! [NSManagedObject]{
                        if let id = sonuc.value(forKey: "id") as? UUID{
                            if id == idArr[indexPath.row]{
                                context.delete(sonuc)
                                nameArr.remove(at: indexPath.row)
                                idArr.remove(at: indexPath.row)
                                self.tableView.reloadData()
                                
                               
                                do{
                                    try context.save()
                                }
                                catch{
                                    print("error127")
                                }
                            }
                        }
                    }
                    
                }
                catch{
                    print("error120")
                }
            
            }
        }
    }

}

