//
//  ChatCellTableViewCell.swift
//  ParseChat
//
//  Created by Henry Guerra on 2/4/19.
//  Copyright © 2019 Henry Guerra. All rights reserved.
//

import UIKit

class ChatCellTableViewCell: UITableViewCell {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var chatMsg: UILabel!
    @IBOutlet weak var bubbleView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
