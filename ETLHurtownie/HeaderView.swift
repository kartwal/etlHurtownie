//
//  HeaderView.swift
//  ETLHurtownie
//
//  Created by Kamil Walas on 27.11.2016.
//  Copyright © 2016 ARIOS. All rights reserved.
//

import UIKit
import FZAccordionTableView

class HeaderView: FZAccordionTableViewHeaderView {

    static let defaultHeaderHeight: CGFloat = 120;
    static let reusableIdentifierHeader = "AccordionHeaderViewReuseIdentifier";

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var type: UILabel!

    @IBOutlet weak var countReviews: UILabel!
   
    @IBOutlet weak var productDescription: UILabel!
}
