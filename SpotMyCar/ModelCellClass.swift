
//
//  ModelCellClass.swift
//  Flash Chat
//
//  Created by Osama Fahim on 24/02/2020.
//  Copyright © 2020 London App Brewery. All rights reserved.
//

import UIKit

class ModelCellClass: UITableViewCell {

    @IBOutlet weak var modelCarImage: UIImageView!
    @IBOutlet weak var modelNameLabel: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
