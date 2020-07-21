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
import Alamofire
import SwiftyJSON

class AllCarsList: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // Declare instance variables here
    var messageArray : [Message] = [Message]()
    var arrRes = [[String:AnyObject]]()
    var username = ""
    
    // We've pre-linked the IBOutlets
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    var topButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.navigationItem.setHidesBackButton(true, animated: false)
        
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTableView.register(UINib(nibName: "CarCell", bundle: nil) , forCellReuseIdentifier: "customMessageCell1")
        
        getUsername()
        configureTableView()
        retrieveMessages()
        messageTableView.separatorStyle = .none
        
        
        
        
    }
    
    //MARK: - TableView Delegate Methods
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell1", for: indexPath) as! CarCell1
        
        //cell.avatarImageView.image = UIImage(named: "audi")
        cell.senderUsername?.text = messageArray[indexPath.row].messageBody
        if messageArray[indexPath.row].sender == "Audi" {
            cell.avatarImageView.image = UIImage(named: "audi1")
        }
        else if messageArray[indexPath.row].sender == "Honda" {
            cell.avatarImageView.image = UIImage(named: "honda")
        }
        else if messageArray[indexPath.row].sender == "Toyota" {
            cell.avatarImageView.image = UIImage(named: "toyo")
        }
        else if messageArray[indexPath.row].sender == "Mercedes" {
            cell.avatarImageView.image = UIImage(named: "4")
        }
        else if messageArray[indexPath.row].sender == "Volkswagen" {
            cell.avatarImageView.image = UIImage(named: "5")
        }
        else if messageArray[indexPath.row].sender == "Ford" {
            cell.avatarImageView.image = UIImage(named: "6")
        }
        else if messageArray[indexPath.row].sender == "BMW" {
            cell.avatarImageView.image = UIImage(named: "7")
        }
        else if messageArray[indexPath.row].sender == "Nissan" {
            cell.avatarImageView.image = UIImage(named: "8")
        }
        else if messageArray[indexPath.row].sender == "Hyundai" {
            cell.avatarImageView.image = UIImage(named: "9")
        }
        else if messageArray[indexPath.row].sender == "KIA" {
            cell.avatarImageView.image = UIImage(named: "10")
        }
        else if messageArray[indexPath.row].sender == "Suzuki" {
            cell.avatarImageView.image = UIImage(named: "11")
        }
        else if messageArray[indexPath.row].sender == "Mazda" {
            cell.avatarImageView.image = UIImage(named: "12")
        }
        else if messageArray[indexPath.row].sender == "Porsche" {
            cell.avatarImageView.image = UIImage(named: "13")
        }
        else if messageArray[indexPath.row].sender == "Peugeot" {
            cell.avatarImageView.image = UIImage(named: "14")
        }
        else if messageArray[indexPath.row].sender == "Mitsubishi" {
            cell.avatarImageView.image = UIImage(named: "15")
        }
        else{
            cell.avatarImageView.image = UIImage(named: "toyo")
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    
    //TODO: Declare configureTableView here:
    
    func configureTableView() {
        messageTableView.rowHeight = UITableView.automaticDimension
        messageTableView.estimatedRowHeight = 120.0
    }
    
    
    func retrieveMessages() {
        
        let messageDB = Database.database().reference().child("Drove")
        
        messageDB.observe(.childAdded) { (snapshot) in
            
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            let model = snapshotValue["CarModel"]!
            let usernamee = snapshotValue["Username"]!
            let modelName = snapshotValue["Model"]!
            
            if self.username == usernamee {
            let message = Message()
            message.messageBody = model
            message.sender = modelName
            
            self.messageArray.append(message)
            print(snapshotValue["CarModel"]!)
            
            self.configureTableView()
            self.messageTableView.reloadData()
            }
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
                
                
                self.configureTableView()
                self.messageTableView.reloadData()
            }
        }
    
    
    
}
