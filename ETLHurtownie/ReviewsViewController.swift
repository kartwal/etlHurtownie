//
//  ReviewsViewController.swift
//  ETLHurtownie
//
//  Created by Kamil Walas on 19.11.2016.
//  Copyright © 2016 ARIOS. All rights reserved.
//
import RealmSwift
import UIKit

class ReviewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    var products = [Product]()
    
    var selectedIndex = Int()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        
        for item in products
        {
            print(item.productType)
            print(item.id)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("product", forIndexPath: indexPath) as!ProductsTableViewCell
        
        cell.productName.text = "Nazwa produktu: " + products[indexPath.row].productName
        cell.productType.text = "Typ produktu: " + products[indexPath.row].productType
        cell.productDescription.text = "Opis: " + products[indexPath.row].additionalDescription
        cell.productId.text = "ID produktu: " + String(products[indexPath.row].id)
        cell.productReviewsCount.text = "Opinie: " + String(products[indexPath.row].reviews.count)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        selectedIndex = indexPath.row
        performSegueWithIdentifier("showDetails", sender: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetails"
        {
            let destination = segue.destinationViewController as! ProductDetailsViewController
            destination.product = products[selectedIndex]
        }
    }
}
