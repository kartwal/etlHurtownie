//
//  ReviewTableViewCell.swift
//  ETLHurtownie
//
//  Created by Kamil Walas on 28.11.2016.
//  Copyright © 2016 ARIOS. All rights reserved.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var reviewText: UITextView!
}
