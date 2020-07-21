//
//  CustomMessageCell.swift
//  Flash Chat
//
//  Created by Angela Yu on 30/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit

protocol UserCellDelegate {
    func didfollowButtonPressed()
}

class UsersCell: UITableViewCell {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var followButton: UIButton!
    
    var delegate : UserCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        
        
    }

    @IBAction func folowButtonPressed(_ sender: UIButton) {
        delegate?.didfollowButtonPressed()
    }
    
}

