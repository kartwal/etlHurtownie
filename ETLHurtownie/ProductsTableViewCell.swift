//
//  ProductsTableViewCell.swift
//  ETLHurtownie
//
//  Created by Kamil Walas on 28.11.2016.
//  Copyright © 2016 ARIOS. All rights reserved.
//

import UIKit

class ProductsTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var productReviewsCount: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productType: UILabel!
    @IBOutlet weak var productId: UILabel!
}
