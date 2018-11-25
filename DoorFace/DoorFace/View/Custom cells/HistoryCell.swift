//
//  HistoryCell.swift
//  DoorFace
//
//  Created by Marcin Kiliszek on 24/11/2018.
//  Copyright © 2018 Marcin Kiliszek. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {

    @IBOutlet weak var doorImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var historyCellBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
