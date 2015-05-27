//
//  UserCell.swift
//  PartyTime
//
//  Created by George Fitzgibbons on 4/23/15.
//  Copyright (c) 2015 Nanigans. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
//style
  override func layoutSubviews() {
        super.layoutSubviews()
    //round the images
    avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
    
    //resize image
    avatarImageView.layer.masksToBounds = true
    
    
    
    }
    
    
}
