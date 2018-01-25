//
//  ForgotReset.swift
//  SHP
//
//  Created by Mark Sandomeno on 8/30/17.
//  Copyright © 2017 SandoStudios. All rights reserved.
//

import UIKit
import Firebase

class ForgotReset: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black,
                                                                   NSAttributedStringKey.font: UIFont(name: "Avenir-Roman", size: 17)!]
        navigationItem.title = "Password Reset"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        view.backgroundColor = UIColor.white
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
        view.addSubview(emailtextField)
        view.addSubview(requestEmailButton)
        view.addSubview(internaltextField)
        setupEmailTextField()
        setupRequestEmailButton()
        setupinternalTextField()
    
    }
    
    let internaltextField: UITextField = {
        let Itf = UITextField()
        Itf.placeholder = "Email:"
        Itf.clearsOnBeginEditing = true
        Itf.textColor = UIColor(r: 80, g: 101, b: 161)
        
        return Itf
        
    }()


let emailtextField: UITextField = {
    let tf = UITextField()
   
    tf.backgroundColor = UIColor(white: 0.95, alpha: 1)
    tf.isEnabled = false
    tf.layer.cornerRadius = 22
    
    tf.translatesAutoresizingMaskIntoConstraints = false
    
    
    return tf
}()
    
    let requestEmailButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Request Reset", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 22
        
        button.addTarget(self, action: #selector(handleRequestEmail), for: .touchUpInside)
        
      
    
        return button
        
        
    }()
    
    
    @objc func handleRequestEmail() {
        
        let alertController = UIAlertController(title: "Email has been sent to: " + internaltextField.text!, message:
            "", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
        
        Auth.auth().sendPasswordReset(withEmail: internaltextField.text! ){ error in
            
        }
        
        print ("email has been sent to " + (internaltextField.text!))
        
    }
    
    func setupinternalTextField() {
        
        internaltextField.topAnchor.constraint(equalTo: emailtextField.topAnchor).isActive = true
        internaltextField.bottomAnchor.constraint(equalTo: emailtextField.bottomAnchor).isActive = true
        internaltextField.leftAnchor.constraint(equalTo: emailtextField.leftAnchor, constant: 10).isActive = true
        internaltextField.rightAnchor.constraint(equalTo: emailtextField.rightAnchor).isActive = true
        
        internaltextField.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupRequestEmailButton() {
        
        requestEmailButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        requestEmailButton.topAnchor.constraint(equalTo: emailtextField.bottomAnchor, constant: 35).isActive = true
        requestEmailButton.widthAnchor.constraint(equalTo: emailtextField.widthAnchor).isActive = true
        requestEmailButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    

    func setupEmailTextField() {
    
        emailtextField.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        emailtextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailtextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -35).isActive = true
        emailtextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
        
    
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }



}
