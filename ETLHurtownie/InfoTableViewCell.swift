//
//  InfoTableViewCell.swift
//  ETLHurtownie
//
//  Created by Kamil Walas on 27.11.2016.
//  Copyright © 2016 ARIOS. All rights reserved.
//

import UIKit
import FZAccordionTableView

class InfoTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var prosAndCons: UITextView!
    @IBOutlet weak var recomend: UILabel!
    @IBOutlet weak var review: UITextView!
    @IBOutlet weak var reviewDate: UILabel!
    @IBOutlet weak var author: UILabel!
}
