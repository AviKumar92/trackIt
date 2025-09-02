//
//  UpdateUserProfileViewController.swift
//  HabitApp
//
//  Created by Avinash kumar on 25/08/25.
//

import UIKit

class UpdateUserProfileViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var txtBloodGroup: UITextField!
    @IBOutlet weak var btnGender: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var btnChangeImage: UIButton!
    @IBOutlet weak var userUpdateProfile: UIImageView!
    var imagePicker:  UIImagePickerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utility.setCornerRadius(view: userUpdateProfile, cornerRadius: 40)
        Utility.setCornerRadius(view: btnUpdate, cornerRadius: 10)
        Utility.setCornerRadius(view: txtName, cornerRadius: 10)
        Utility.setCornerRadius(view: btnGender, cornerRadius: 10)
        Utility.setCornerRadius(view: txtBloodGroup, cornerRadius: 10)
        Utility.setCornerRadius(view: txtLastName, cornerRadius: 10)
        imagePicker = UIImagePickerController()
        self.imagePicker?.delegate = self
        

       
    }


    @IBAction func onClickChangedBtn(_ sender: Any) {
        let alert  = UIAlertController(title: "Select Image", message: "", preferredStyle: .actionSheet)
        alert.modalPresentationStyle = .overCurrentContext
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        let popoverController = alert.popoverPresentationController
        
        popoverController?.permittedArrowDirections = .up
        
        
        self.present(alert, animated: true, completion: nil)
    }
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker?.sourceType = UIImagePickerController.SourceType.camera
            imagePicker?.allowsEditing = true
            self.present(imagePicker!, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Muzyfy", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func openGallary() {
        self.imagePicker?.delegate = self
        imagePicker?.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker?.allowsEditing = true
        self.present(imagePicker!, animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image  = info[UIImagePickerController.InfoKey(rawValue:  UIImagePickerController.InfoKey.originalImage.rawValue) ] as? UIImage {
            userUpdateProfile.image = image
//            selectedProfileImg = image
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func onClickUpdateBtn(_ sender: Any) {
    }
    
}
