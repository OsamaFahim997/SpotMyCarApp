//
//  CustomMessageCell.swift
//  Flash Chat
//
//  Created by Osama Fahim on 22/02/2020.
//  Copyright © 2020 London App Brewery. All rights reserved.
//

import UIKit

class CustomMessageCell: UITableViewCell {

    @IBOutlet weak var messageBody: UILabel!
    @IBOutlet weak var senderUsername: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

}
