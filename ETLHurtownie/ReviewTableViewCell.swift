//
//  ReviewTableViewCell.swift
//  ETLHurtownie
//
//  Created by Kamil Walas on 28.11.2016.
//  Copyright © 2016 uek. All rights reserved.
//

import UIKit
/**
 Klasa odpowiedzialna za wiersz recenzji
 */
class ReviewTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    /**
     TextField do wyświetlania danych
     */
    @IBOutlet weak var reviewText: UITextView!
}
