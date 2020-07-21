//
//  RankTableViewController.swift
//  Flash Chat
//
//  Created by Osama Fahim on 24/02/2020.
//  Copyright © 2020 London App Brewery. All rights reserved.
//

import UIKit
import Firebase
import Foundation

class RankTableViewController: UITableViewController {

    var messageArray : [Message] = [Message]()
    var username = ""
    var array = [String]()
    
    @IBOutlet var rankTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //getUsername()
        let otherVC = LogInViewController()
        username = otherVC.username
        print(username)
        
        retrieveData2()
        //retrieveData()
        
        rankTableView.delegate = self
        rankTableView.dataSource = self
        rankTableView.register(UINib(nibName: "RankCell", bundle: nil) , forCellReuseIdentifier: "customMessageCell5")
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messageArray.count
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell5", for: indexPath) as! CustomRankCell
        
        cell.senderUsername.text = messageArray[indexPath.row].sender
        let percentage = Double(messageArray[indexPath.row].messageBody)
        var ans = percentage!/500
        ans = ans.truncate(places: 4)
        cell.percentageLabel.text = "\(ans)%"
        
        
        
        return cell
    }
    
    func retrieveData2() {
        
        
        let ref = Database.database().reference(withPath: "Rank/\(username)")
        ref.observe(.value, with: { snapshot in
            for child in snapshot.children {
                // 4
                if let snapshot = child as? DataSnapshot{
                    
                    let sender = snapshot.childSnapshot(forPath: "Username").value as! String
                    
                    let message = Message()
                    message.sender = sender
                    message.messageBody = snapshot.childSnapshot(forPath: "CarsDrove").value as! String
                    message.sender = snapshot.childSnapshot(forPath: "Username").value as! String

                    self.messageArray.append(message)
                    self.configureTableView()
                    self.rankTableView.reloadData()
            
                }
        }
        })
    }
    
    func configureTableView() {
        rankTableView.rowHeight = UITableView.automaticDimension
        rankTableView.estimatedRowHeight = 120.0
    }
    
    func getUsername(){
        let messageDB = Database.database().reference().child("Users")
        
        messageDB.observe(.childAdded) { (snapshot) in
            
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            let text = snapshotValue["Username"]!
            let sender = snapshotValue["Sender"]!
            
            if sender == Auth.auth().currentUser?.email{
                self.username = text
                print("Hello")
               // print(self.username)
            }
            
            
            self.configureTableView()
            self.rankTableView.reloadData()
        }
    }
}

extension Double
{
    func truncate(places : Int)-> Double
    {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
}
