//
//  ViewController.swift
//  Flash Chat
//
//  Created by Angela Yu on 29/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework
import SVProgressHUD


class AllUsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UserCellDelegate {
    
    // Declare instance variables here
    var messageArray : [Message] = [Message]()
    var username = ""
    
    // We've pre-linked the IBOutlets
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var messageTableView: UITableView!
    @IBOutlet weak var TableVieww: UITableView!
    
    var topButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        getUsername()
        TableVieww.delegate = self
        TableVieww.dataSource = self
        TableVieww.register(UINib(nibName: "UserCell", bundle: nil) , forCellReuseIdentifier: "customMessageCell3")
        
        configureTableView()
        
        retrieveMessages()
        
        TableVieww.separatorStyle = .none
        
    }
    
    
    
    //MARK: - TableView Delegate Methods
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell3", for: indexPath) as! UsersCell
        
        
        cell.username.text = messageArray[indexPath.row].messageBody
       /// cell.userImage.image = UIImage(named: "audi")
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Follow?", message: "Do you want to follow this user?", preferredStyle: UIAlertController.Style.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: {
            action in
            
            SVProgressHUD.show()
            let messagesDB = Database.database().reference().child("Follow/\(self.username)")
            
            let messageDictionary = ["Username" : self.messageArray[indexPath.row].messageBody]
            
            messagesDB.childByAutoId().setValue(messageDictionary){
                (error, reference) in
                
                if error != nil {
                    print(error!)
                }
                else {
                    print("Message saved successfully!")
                }
            }
            SVProgressHUD.dismiss()
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    //TODO: Declare configureTableView here:
    
    func configureTableView() {
        TableVieww.rowHeight = UITableView.automaticDimension
        TableVieww.estimatedRowHeight = 120.0
    }
    
    
    func retrieveMessages() {
        
        let messageDB = Database.database().reference().child("Users")
        
        messageDB.observe(.childAdded) { (snapshot) in
            
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            let text = snapshotValue["Username"]!
            let sender = snapshotValue["Sender"]!
            
            if text != self.username{
            let message = Message()
            message.messageBody = text
            message.sender = sender
            
            self.messageArray.append(message)
            }
            
            self.configureTableView()
            self.TableVieww.reloadData()
            
            
            
        }
        
    }
    
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        
        do {
            try Auth.auth().signOut()
            
            navigationController?.popToRootViewController(animated: true)
            
        }
        catch {
            print("error: there was a problem logging out")
        }
        
    }
    
    func didfollowButtonPressed() {
    }
    
    func getUsername(){
        let messageDB = Database.database().reference().child("Users")
        
        messageDB.observe(.childAdded) { (snapshot) in
            
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            let text = snapshotValue["Username"]!
            let sender = snapshotValue["Sender"]!
            
            if sender == Auth.auth().currentUser?.email{
                self.username = text
                print(self.username)
            }
        }
    }
    
}

