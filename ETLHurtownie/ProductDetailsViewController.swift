//
//  ProductDetailsViewController.swift
//  ETLHurtownie
//
//  Created by Kamil Walas on 28.11.2016.
//  Copyright © 2016 ARIOS. All rights reserved.
//

import UIKit

class ProductDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var product = Product()
    
    var reviewString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewDidAppear(animated: Bool) {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return product.reviews.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("review", forIndexPath: indexPath) as! ReviewTableViewCell
        cell.reviewText.text = reviewString
        cell.reviewText.sizeThatFits(cell.frame.size)
        cell.reviewText.scrollEnabled = true
        cell.reviewText.scrollEnabled = false
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        reviewString = ""
        
        reviewString += "Autor opinii: " + product.reviews[indexPath.row].author.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) + "\n"

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        reviewString += "Data opinii: " + dateFormatter.stringFromDate(product.reviews[indexPath.row].reviewDate) + "\n"

        reviewString += "Rekomendacja: " + String(product.reviews[indexPath.row].recomended) + "\n"
        
        reviewString += "Opinia: " + product.reviews[indexPath.row].body.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())

        if product.reviews[indexPath.row].advantages.count > 0
        {
            reviewString += "\n\nZalety: \n"
            for item in product.reviews[indexPath.row].advantages
            {
                reviewString += item.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) + "\n"
            }
        }
        reviewString += "\n"
        
        if product.reviews[indexPath.row].advantages.count > 0
        {
            reviewString += "Wady: \n"
            for item in product.reviews[indexPath.row].drawbacks
            {
                reviewString += item.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) + "\n"
            }
        }

        print(reviewString)
        let testView = UITextView()
        testView.text = reviewString
        testView.font = UIFont.systemFontOfSize(15)
        let screenBounds = UIScreen.mainScreen().bounds
        let size = screenBounds.size
        let sizeNew = testView.sizeThatFits(CGSizeMake(size.width - 10, CGFloat(FLT_MAX)))

        return sizeNew.height

    }
}
