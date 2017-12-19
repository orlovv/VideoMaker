//
//  TableViewCell.swift
//  VideoMaker
//
//  Created by Иван Свиридов on 18.12.2017.
//  Copyright © 2017 Иван Свиридов. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var videoPreview: UIImageView!
    @IBOutlet weak var videoName: UILabel!
    @IBOutlet weak var videoLength: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
