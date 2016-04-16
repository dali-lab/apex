//
//  FeedTableViewCell.swift
//  Apex
//
//  Created by ArminM on 4/16/16.
//  Copyright © 2016 DALI. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var dateTime: UILabel!
    @IBOutlet weak var registration: UILabel!
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var icon: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
