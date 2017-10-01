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
        
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        view.backgroundColor = UIColor.white
        
        
        view.addSubview(emailtextField)
        view.addSubview(requestEmailButton)
        setupEmailTextField()
        setupRequestEmailButton()
    
    }


let emailtextField: UITextField = {
    let tf = UITextField()
    tf.placeholder = "      Email:"
    tf.clearsOnBeginEditing = true
    tf.textColor = UIColor(r: 80, g: 101, b: 161)
    tf.backgroundColor = UIColor(white: 0.95, alpha: 1)
    tf.layer.cornerRadius = 22
    
    tf.translatesAutoresizingMaskIntoConstraints = false
    
    
    return tf
}()
    
    let requestEmailButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Request Email", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 22
        
        button.addTarget(self, action: #selector(handleRequestEmail), for: .touchUpInside)
        
      
    
        return button
        
        
    }()
    
    
    func handleRequestEmail() {
        
        FIRAuth.auth()?.sendPasswordReset(withEmail: emailtextField.text!) { error in
        
        }
        
        print ("email has been sent")
        emailtextField.text = ""
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
    
    func handleCancel() {
        dismiss(animated: true, completion: nil)
    }



}
