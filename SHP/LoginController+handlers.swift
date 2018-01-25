//
//  LoginController+handlers.swift
//  SHP
//
//  Created by Mark Sandomeno on 6/14/17.
//  Copyright © 2017 SandoStudios. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func handleRegister() {
        
        
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print("Form is not valid")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil
            {
                print(123456)
                return
            }
            
            let center = UNUserNotificationCenter.current()
            let options: UNAuthorizationOptions = [.alert, .badge, .sound]
            center.requestAuthorization(options: options, completionHandler: { (granted, error) in
                if granted {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            })
            self.messagesController?.fetchUserAndSetupNavBarTitle()
            
            self.dismiss(animated: true, completion: nil)

    

            
            guard let uid = user?.uid else {
                return
            }
            
            
            //successfully authenticated user
            let imageName = UUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
            
           
           
            
            if let profileImage = self.profileImageView.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
               
                
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    
                    if error != nil {
                        print(error ?? "")
                        return
                    }
                    
                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                        
                        let values = ["name": name, "email": email, "profileImageUrl": profileImageUrl]
                        
                        self.registerUserIntoDatabaseWithUID(uid, values: values as [String : AnyObject])
                    }
                })
            }
        })
    }
    
    
    fileprivate func registerUserIntoDatabaseWithUID(_ uid: String, values: [String: AnyObject]) {
        let ref = Database.database().reference()
        //added child users
        let usersReference = ref.child("users").child(uid)
        
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err ?? "")
                return
            }
    
         
           let user = User(dictionary: values)
           self.messagesController?.setupNavBarWithUser(user)
            
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    
//    func handleSelectProfileImageView() {
//
//
//        let picker = UIImagePickerController()
//
//        picker.delegate = self
//        picker.allowsEditing = true
//
//
//        present(picker, animated: true, completion: nil)
//    }
//
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//
//        var selectedImageFromPicker: UIImage?
//
//
//        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
//            selectedImageFromPicker = editedImage
//
//        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
//
//            selectedImageFromPicker = originalImage
//        }
//
//        if let selectedImage = selectedImageFromPicker {
//            profileImageView.image = selectedImage
//        }
//
//        dismiss(animated: true, completion: nil)
//
//    }
//
//
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//
//        dismiss(animated: true, completion: nil)
//    }
//
//}

}
