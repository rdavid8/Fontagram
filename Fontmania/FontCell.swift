//
//  FontCell.swift
//  Fontagram
//
//  Created by Ryan David on 2/28/16.
//  Copyright © 2016 Ryan David. All rights reserved.
//

import UIKit

class FontCell: UITableViewCell {

    @IBOutlet weak var fontLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clearColor()
        self.contentView.backgroundColor = UIColor.clearColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
