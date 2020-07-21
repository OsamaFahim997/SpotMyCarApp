//
//  LogInViewController.swift
//  Flash Chat
//
//  This is the view controller where users login


import UIKit
import Firebase
import SVProgressHUD

class LogInViewController: UIViewController {

    //Textfields pre-linked with IBOutlets
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    var username = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUsername()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

   
    //Log in an existing user
    
    @IBAction func logInPressed(_ sender: AnyObject) {
        
        SVProgressHUD.show()
        
        Auth.auth().signIn(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (user, error) in
            
            if error != nil {
                print(error!)
            } else {
                print("Log in successful!")
                
                SVProgressHUD.dismiss()
                
                self.getUsername()
                if self.username != nil {
                self.performSegue(withIdentifier: "goToChat", sender: self)
                }
            }
            
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
        }
    }
    


    
}  
