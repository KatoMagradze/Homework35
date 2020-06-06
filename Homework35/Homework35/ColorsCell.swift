//
//  ColorsCell.swift
//  Homework35
//
//  Created by Kato on 6/5/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit

class ColorsCell: UITableViewCell {

    @IBOutlet weak var colorImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var hexLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
