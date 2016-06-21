//
//  incidentListCellTableViewCell.swift
//  ehss
//
//  Created by IOS1-PC on 5/14/16.
//  Copyright (c) 2016 AgdanL. All rights reserved.
//

import UIKit

class incidentListCell: UITableViewCell {

    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
