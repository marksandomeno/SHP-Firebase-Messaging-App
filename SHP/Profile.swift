//
//  Profile.swift
//  SHP
//
//  Created by Mark Sandomeno on 8/22/17.
//  Copyright © 2017 SandoStudios. All rights reserved.
//


import UIKit
import Firebase
import FirebaseAuth



class Profile : UITableViewController, UINavigationControllerDelegate{
    
     let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.backgroundColor = UIColor.white
      
        fetchUserForNavBar()
        fetchAllArrayData()
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black,
                                                                   NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 18)!]
        
       
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.allowsMultipleSelectionDuringEditing = true
        
        
       
      
        
    }
    
    
     var mainArray = [String](arrayLiteral: "")
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        
        return mainArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = mainArray[indexPath.item]
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    

    
     func fetchAllArrayData() {
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            //for some reason uid = nil
            return
        }
        
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                //self.navigationItem.title = dictionary["name"] as? String
                self.mainArray.append(dictionary["name"] as! String)
                self.mainArray.append(dictionary["email"] as! String)
                self.mainArray.append(dictionary["profileImageUrl"] as! String)
                
                print(self.mainArray)
                
                
              
           
            }
            
        }, withCancel: nil)
        
        
    }


    func handleCancel() {
        dismiss(animated: true, completion: nil)
        
    }
    
    
    func handleLogout() {
        
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
        
        
    }
    
    

    func fetchUserForNavBar() {
        
        //fetch current users name and displays as navbar title
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            //for some reason uid = nil
            return
        }
        
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
            self.navigationItem.title = dictionary["name"] as? String
                
                
      
            }
            
        }, withCancel: nil)
        
       
 
 
  }
    
    
    


}





