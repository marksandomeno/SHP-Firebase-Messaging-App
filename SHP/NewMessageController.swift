//
//  NewMessageController.swift
//  SHP
//
//  Created by Mark Sandomeno on 5/6/17.
//  Copyright © 2017 Sando. All rights reserved.
//

import UIKit
import Firebase


extension NewMessageController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}


class NewMessageController: UITableViewController, UISearchBarDelegate {
    
    let cellId = "cellId"
    
    
    var users = [User]()
    var filteredUsers = [User]()
    var shouldShowSearchResults = false
    var searchController: UISearchController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black ,
                                                                   NSAttributedStringKey.font: UIFont(name: "Avenir-Roman", size: 18)!]
        navigationItem.title = "Directory"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel" , style: .plain, target: self, action: #selector(handleCancel))
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        fetchUser()
        
        configureSearchController()
        
        filterContentForSearchText(searchText: searchController.searchBar.text!)
        

        
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "Current") {
        filteredUsers = users.filter { user in
            return (user.name?.lowercased().contains(searchText.lowercased()))!
         
        }
        
        
        tableView.reloadData()
    }
    
    
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredUsers.count
        }
        return users.count
    }
    
    
    
    func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = ""
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.backgroundColor = .white
        
        
        
        tableView.tableHeaderView = searchController.searchBar
        
    }
    
    
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        
        searchController.dimsBackgroundDuringPresentation = false
        tableView.isUserInteractionEnabled = true
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            
        }
        
        searchController.searchBar.resignFirstResponder()
    }
    
    
    func fetchUser() {
        
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User(dictionary: dictionary)
                user.id = snapshot.key
                self.users.append(user)
                
                
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
                
                
            }
            
        }, withCancel: nil)
    }
    
    
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        let user: User
        if searchController.isActive && searchController.searchBar.text != "" {
            user = filteredUsers[indexPath.row]
            
            
        } else {
            user = users[indexPath.row]
            
        }
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        if let profileImageUrl = user.profileImageUrl {
            cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    
    var messagesController: MessagesController?
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        if searchController.isActive && searchController.searchBar.text != "" {
           
          dismiss(animated: false, completion: nil)
            
            dismiss(animated: true) {
                
                let user = self.filteredUsers[indexPath.row]
                self.messagesController?.showChatControllerForUser(user)
               
            }
            


        }else {
            
            
            dismiss(animated: true) {
                
                let user = self.users[indexPath.row]
                self.messagesController?.showChatControllerForUser(user)
                
            }

            
        }
        
        
    }
    
 
}




