//
//  DeactivateAccountPage.swift
//  SHP
//
//  Created by Mark Sandomeno on 10/20/17.
//  Copyright © 2017 Sando. All rights reserved.
//

import UIKit
import Firebase

class DeactivateAccountPage: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black,
                                                                   NSAttributedStringKey.font: UIFont(name: "Avenir-Roman", size: 17)!]
        navigationItem.title = "Deactiave Account"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
       
        view.addSubview(Goodbye)
        setupGoodbye()

    
    }
    
    let Goodbye: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.red
        button.setTitle("Deactivate Me", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 22
        
        button.addTarget(self, action: #selector(handleGoodbye), for: .touchUpInside)
        
        
        
        return button
        
        
    }()
    
    
    
   @objc func handleGoodbye() {
    
    //get current users uid
    guard let uid = Auth.auth().currentUser?.uid else{
        
        return
    }
    
    let user = Auth.auth().currentUser
    
    //delete from database
    
    Database.database().reference().child("users").child(uid).removeValue(completionBlock: { (error, ref) in
        
        if error != nil {
            //didnt work for database
            print ("failed to delete user from database")
            return
        }
        
        //worked in deleteing from database
        //then when its out of database, get out of auth ---->
      
          })
    
    //delete from auth
        user?.delete { error in
            if error != nil {
                //error occured for auth
                
                
                
            } else {
                
                // Account deleted.
                self.handleLogout()
                
            }
    }
  
  
}

    
    func setupGoodbye() {
        
        Goodbye.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        Goodbye.widthAnchor.constraint(equalToConstant: 300).isActive = true
        Goodbye.heightAnchor.constraint(equalToConstant: 47).isActive = true
        Goodbye.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
    
  
    
   @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
   @objc func handleLogout() {
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
        
    }
    
    
    
}





