//
//  DetailsViewController.swift
//  ShoppingList
//
//  Created by Fuat Bolat on 20.10.2024.
//

import UIKit
import Photos
import CoreData


class DetailsViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var productNameTextField: UITextField!
    
    @IBOutlet weak var priceTextField: UITextField!
    
    @IBOutlet weak var sizeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       
        imageView.isUserInteractionEnabled = true
        let imageGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(imageTapped))
        imageView.addGestureRecognizer(imageGestureRecognizer)
        //when the user tap the screen
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(dissMissKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
        
    }
    @objc func imageTapped() {
       PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                print("erişim izni verildi")
                return
                
            }
            
        }
       
        
        ///
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = false
        present(picker, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        picker.dismiss(animated: true)
    }
    

    
    @objc func dissMissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let shopping = NSEntityDescription.insertNewObject(forEntityName: "Shopping", into: context)
        
        shopping.setValue(UUID(), forKey: "id")
        shopping.setValue(productNameTextField.text!, forKey: "name")
        let photoToData = imageView.image?.jpegData(compressionQuality: 0.5)
        shopping.setValue(photoToData, forKey: "photo")
        
        if let price = Int(priceTextField.text!){
            shopping.setValue(price, forKey: "price")
        }
        shopping.setValue(sizeTextField.text!, forKey: "size")
        
        do {
            try context.save()
            print("saved")
            
        }catch{
            print("an error occured while saving")
        }
        
        
        
        
    }
  
}
