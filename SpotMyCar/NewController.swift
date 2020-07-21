//
//  NewController.swift
//  Flash Chat
//
//  Created by Osama Fahim on 24/02/2020.
//  Copyright © 2020 London App Brewery. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Firebase
import SVProgressHUD

class NewController: UITableViewController {

    var selectedModel = ""
    var arrRes = [[String:AnyObject]]()
    var username = ""
    var carsDrove = 1
    
    @IBOutlet var carsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(selectedModel)
        getCarsList()
        getUsername()
        carsTableView.delegate = self
        carsTableView.dataSource = self
        carsTableView.register(UINib(nibName: "ModelCell", bundle: nil) , forCellReuseIdentifier: "customMessageCell4")
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrRes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell4", for: indexPath) as! ModelCellClass
        
        var dict = arrRes[indexPath.row]
        cell.modelNameLabel.text = dict["Model_Name"] as? String
        if selectedModel == "Audi" {
            cell.modelCarImage.image = UIImage(named: "audi1")
        }
        else if selectedModel == "Honda" {
            cell.modelCarImage.image = UIImage(named: "honda")
        }
        else if selectedModel == "Toyota" {
            cell.modelCarImage.image = UIImage(named: "toyo")
        }
        else if selectedModel == "Mercedes" {
            cell.modelCarImage.image = UIImage(named: "4")
        }
        else if selectedModel == "Volkswagen" {
            cell.modelCarImage.image = UIImage(named: "5")
        }
        else if selectedModel == "Ford" {
            cell.modelCarImage.image = UIImage(named: "6")
        }
        else if selectedModel == "BMW" {
            cell.modelCarImage.image = UIImage(named: "7")
        }
        else if selectedModel == "Nissan" {
            cell.modelCarImage.image = UIImage(named: "8")
        }
        else if selectedModel == "Hyundai" {
            cell.modelCarImage.image = UIImage(named: "9")
        }
        else if selectedModel == "KIA" {
            cell.modelCarImage.image = UIImage(named: "10")
        }
        else if selectedModel == "Suzuki" {
            cell.modelCarImage.image = UIImage(named: "11")
        }
        else if selectedModel == "Mazda" {
            cell.modelCarImage.image = UIImage(named: "12")
        }
        else if selectedModel == "Porsche" {
            cell.modelCarImage.image = UIImage(named: "13")
        }
        else if selectedModel == "Peugeot" {
            cell.modelCarImage.image = UIImage(named: "14")
        }
        else if selectedModel == "Mitsubishi" {
            cell.modelCarImage.image = UIImage(named: "15")
        }
        else{
            cell.modelCarImage.image = UIImage(named: "toyo")
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var dict = arrRes[indexPath.row]
        let alert = UIAlertController(title: "Drove?", message: "Do you have drove this model?", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: {
                    action in
        
        SVProgressHUD.show()
        let messagesDB = Database.database().reference().child("Drove/")
        
            let messageDictionary = ["CarModel" : dict["Model_Name"] as? String ,"Username" : self.username, "Model" :  dict["Make_Name"] as? String]
        
        messagesDB.childByAutoId().setValue(messageDictionary) {
                (error, reference) in
        
                if error != nil {
                    print(error!)
                }
                else {
                    print("Message saved successfully!")
                }
                }
            
            let messagesDB1 = Database.database().reference().child("Rank/\(self.username)")
            let messageDictionary1 = ["CarsDrove" : "\(self.carsDrove)" ,"Username" : self.username ]
            
            messagesDB1.removeValue() {
                (error, reference) in
                
                if error != nil {
                    print(error!)
                }
                else {
                    print("Message Delete successfully!")
                }
            }
            
            let messagesDB2 = Database.database().reference(withPath: "Rank").child("\(self.username)")
            let messageDictionary2 = ["CarsDrove" : "\(self.carsDrove)" ,"Username" : self.username ]
            
            messagesDB2.setValue(messageDictionary2) {
                (error, reference) in
                
                if error != nil {
                    print(error!)
                }
                else {
                    print("Message Delete successfully!")
                }
            }
            
            SVProgressHUD.dismiss()
        
            }))
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: nil))
        //carsDrove = 0
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    func configureTableView() {
        carsTableView.rowHeight = UITableView.automaticDimension
        carsTableView.estimatedRowHeight = 120.0
    }
    
    func getCarsList(){
                let urlString = "https://vpic.nhtsa.dot.gov/api/vehicles/getmodelsformake/\(selectedModel)?format=json"
        
                Alamofire.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON{
                    response in
                    switch response.result {
                    case .success:
                        print(response)
                        let swiftyJsonVar = JSON(response.result.value!)
                        //print(swiftyJsonVar)
                        if let resData = swiftyJsonVar["Results"].arrayObject {
                            self.arrRes = resData as! [[String:AnyObject]]
                            print(self.arrRes[0])
                        }
                        if self.arrRes.count > 0 {
                            self.carsTableView.reloadData()
                        }
                        
                        break
                    case .failure(let error):
                        print("Error")
                        print(error)
                    }
                }
        
                self.configureTableView()
                self.carsTableView.reloadData()
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
        
        let messageDB1 = Database.database().reference().child("Drove")
        
        messageDB1.observe(.childAdded) { (snapshot) in
            
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            let cars = snapshotValue["CarModel"]!
            let sender = snapshotValue["Username"]!
            print("cars is \(cars)")
            if sender == self.username{
                self.carsDrove = self.carsDrove + 1
            }
        }

    }
}
