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


class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // Declare instance variables here
    var messageArray : [Message] = [Message]()
    var username = ""
    
    // We've pre-linked the IBOutlets
    var brandArray = ["Audi", "Honda", "Toyota","Mercedes","Volkswagen","Ford","BMW","Nissan","Hyundai","KIA","Suzuki","Mazda","Porsche","Peugeot","Mitsubishi"]
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    var topButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil) , forCellReuseIdentifier: "customMessageCell")
        let otherVC = LogInViewController()
        username = otherVC.username
        print(username)
        getUsername()
        configureTableView()
        retrieveMessages()
        messageTableView.separatorStyle = .none
        
        
   
    }


    
    //MARK: - TableView Delegate Methods
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        
        cell.senderUsername.text = brandArray[indexPath.row]
        if brandArray[indexPath.row] == "Audi" {
            cell.avatarImageView.image = UIImage(named: "audi1")
        }
        else if brandArray[indexPath.row] == "Honda" {
            cell.avatarImageView.image = UIImage(named: "honda")
        }
        else if brandArray[indexPath.row] == "Toyota" {
            cell.avatarImageView.image = UIImage(named: "toyo")
        }
        else if brandArray[indexPath.row] == "Mercedes" {
            cell.avatarImageView.image = UIImage(named: "4")
        }
        else if brandArray[indexPath.row] == "Volkswagen" {
            cell.avatarImageView.image = UIImage(named: "5")
        }
        else if brandArray[indexPath.row] == "Ford" {
            cell.avatarImageView.image = UIImage(named: "6")
        }
        else if brandArray[indexPath.row] == "BMW" {
            cell.avatarImageView.image = UIImage(named: "7")
        }
        else if brandArray[indexPath.row] == "Nissan" {
            cell.avatarImageView.image = UIImage(named: "8")
        }
        else if brandArray[indexPath.row] == "Hyundai" {
            cell.avatarImageView.image = UIImage(named: "9")
        }
        else if brandArray[indexPath.row] == "KIA" {
            cell.avatarImageView.image = UIImage(named: "10")
        }
        else if brandArray[indexPath.row] == "Suzuki" {
            cell.avatarImageView.image = UIImage(named: "11")
        }
        else if brandArray[indexPath.row] == "Mazda" {
            cell.avatarImageView.image = UIImage(named: "12")
        }
        else if brandArray[indexPath.row] == "Porsche" {
            cell.avatarImageView.image = UIImage(named: "13")
        }
        else if brandArray[indexPath.row] == "Peugeot" {
            cell.avatarImageView.image = UIImage(named: "14")
        }
        else if brandArray[indexPath.row] == "Mitsubishi" {
            cell.avatarImageView.image = UIImage(named: "15")
        }
        else{
             cell.avatarImageView.image = UIImage(named: "toyo")
        }

        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return brandArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToCars", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! NewController
        
        if let indexPath = messageTableView.indexPathForSelectedRow{
            destination.selectedModel = self.brandArray[indexPath.row]
        }
    }
    
    
    func configureTableView() {
        messageTableView.rowHeight = UITableView.automaticDimension
        messageTableView.estimatedRowHeight = 120.0
    }

    
    
    func retrieveMessages() {
        
        let messageDB = Database.database().reference().child("Messages")
        
        messageDB.observe(.childAdded) { (snapshot) in
            
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            let text = snapshotValue["MessageBody"]!
            let sender = snapshotValue["Sender"]!
            
            let message = Message()
            message.messageBody = text
            message.sender = sender
        
            self.messageArray.append(message)
        

                self.configureTableView()
                self.messageTableView.reloadData()
        }
        
    }

    
    ////////////////////////////////////////////////
    
    //MARK - Log Out Method

    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        
        do {
            try Auth.auth().signOut()
            
            navigationController?.popToRootViewController(animated: true)
            
        }
        catch {
            print("error: there was a problem logging out")
        }

    }
    
    func getUsername(){
        let messageDB = Database.database().reference().child("Users")
        
        messageDB.observe(.childAdded) { (snapshot) in
            
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            let text = snapshotValue["Username"]!
            let sender = snapshotValue["Sender"]!
            
            if sender == Auth.auth().currentUser?.email{
                self.username = text
                UserDefaults.standard.set("osamafahim997", forKey: "Key")
                print(self.username)
            }
            
            
            self.configureTableView()
            self.messageTableView.reloadData()
        }
    }
    


}
