//
//  ProductsTableViewCell.swift
//  ETLHurtownie
//
//  Created by Kamil Walas on 28.11.2016.
//  Copyright © 2016 uek. All rights reserved.
//

import UIKit
/**
 Klasa obsługująca wiersz produktu
 */
class ProductsTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    /**
     Label do wyświetlania danych - szczegóły który to label znajdują się w Main.storyboard
     */
    @IBOutlet weak var productReviewsCount: UILabel!
    /**
     Label do wyświetlania danych - szczegóły który to label znajdują się w Main.storyboard
     */
    @IBOutlet weak var productDescription: UILabel!
    /**
     Label do wyświetlania danych - szczegóły który to label znajdują się w Main.storyboard
     */
    @IBOutlet weak var productName: UILabel!
    /**
     Label do wyświetlania danych - szczegóły który to label znajdują się w Main.storyboard
     */
    @IBOutlet weak var productType: UILabel!
    /**
     Label do wyświetlania danych - szczegóły który to label znajdują się w Main.storyboard
     */
    @IBOutlet weak var productId: UILabel!
}
