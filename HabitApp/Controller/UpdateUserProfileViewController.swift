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
    var selectedProfileImg: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        Utility.setCornerRadius(view: userUpdateProfile, cornerRadius: 40)
        Utility.setCornerRadius(view: btnUpdate, cornerRadius: 10)
        Utility.setCornerRadius(view: txtName, cornerRadius: 10)
        Utility.setCornerRadius(view: btnGender, cornerRadius: 10)
        Utility.setCornerRadius(view: txtBloodGroup, cornerRadius: 10)
        Utility.setCornerRadius(view: txtLastName, cornerRadius: 10)
        imagePicker = UIImagePickerController()
        self.imagePicker?.delegate = self
        
        addDoneButtonOnKeyboard(for: txtName)
        addDoneButtonOnKeyboard(for: txtLastName)
        addDoneButtonOnKeyboard(for: txtBloodGroup)
        addDoneButtonOnKeyboard(for: btnGender)
       
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let top = UIColor(red: 158/255, green: 235/255, blue: 199/255, alpha: 1)   // #9EEBC7
                let bottom = UIColor(red: 255/255, green: 241/255, blue: 166/255, alpha: 1) // #FFF1A6
                view.applyGradient(colors: [top, bottom])
    }
    func addDoneButtonOnKeyboard(for textField: UITextField) {
           let toolbar = UIToolbar()
           toolbar.sizeToFit()
           
           let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
           let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTapped))
           
           toolbar.items = [flexSpace, doneButton]
           textField.inputAccessoryView = toolbar
       }
       
       @objc func doneTapped() {
           view.endEditing(true) // hides keyboard for all textfields
       }
       
       // Optional: Hide keyboard when pressing return
       func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textField.resignFirstResponder()
           return true
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
            selectedProfileImg = image
            
            if let pickedImage = selectedProfileImg,
               let imageData = pickedImage.jpegData(compressionQuality: 0.8) {
                SessionManager.shared.currentUser?.profileImage = imageData
                
                // Save back to Core Data
                AuthDataHelper.shared.saveContext()
            }

            
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func onClickUpdateBtn(_ sender: Any) {
        
        guard let email = UserDefaults.standard.string(forKey: "loggedInUserEmail") else { return }
               
               let success = AuthDataHelper.shared.updateUser(
                   email: email,
                   firstName: txtName.text,
                   lastName: txtLastName.text,
                   bloodGroup: txtBloodGroup.text,
                   dob: Date(),
                   profileImage: selectedProfileImg
               )
               
        if success {
            Utility.showAlertWithAction(withTitle: "Success", message: "Profile successful updated") {
                //                       print(successResponse)
                if (self.navigationController != nil) {
                    
                    self.navigationController?.popViewController(animated: true);
                }
                
            }} else {
                   Utility.showAlert(Messeage: "Failed to update profile", ParentViewController: self)
               }
    }
    
}
