//
//  auditListCell.swift
//  ehss
//
//  Created by IOS1-PC on 5/16/16.
//  Copyright (c) 2016 AgdanL. All rights reserved.
//

import UIKit

class auditListCell: UITableViewCell {
    
    
    @IBOutlet weak var txtAuditNumber: UILabel!
    @IBOutlet weak var txtAuditTitle: UILabel!
    @IBOutlet weak var txtAuditor: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
