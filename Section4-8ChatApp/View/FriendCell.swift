//
//  FriendCell.swift
//  Section4-8ChatApp
//
//  Created by Jonathan Compton on 7/6/18.
//  Copyright © 2018 Jonathan Compton. All rights reserved.
//

import UIKit

class FriendCell: UITableViewCell {
    
    @IBOutlet weak var bodyLabel : UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageBubbleView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageBubbleView.layer.cornerRadius = 6.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
