//
//  ReviewsViewController.swift
//  ETLHurtownie
//
//  Created by Kamil Walas on 19.11.2016.
//  Copyright © 2016 ARIOS. All rights reserved.
//
import RealmSwift
import UIKit
import FZAccordionTableView

class ReviewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FZAccordionTableViewDelegate {

    @IBOutlet weak var tableView: FZAccordionTableView!
    
    var products = [Product]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        tableView.registerNib(UINib(nibName: "HeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier: HeaderView.reusableIdentifierHeader)
        
        
        let realm = try! Realm()
        for product in realm.objects(Product)
        {
            products.append(product)
        }
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return HeaderView.defaultHeaderHeight
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableView.rowHeight
    }
    
    func tableView(tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return tableView.sectionHeaderHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! InfoTableViewCell
        
        
        
        
        return cell
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterViewWithIdentifier(HeaderView.reusableIdentifierHeader)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: FZAccordionTableView, willOpenSection section: Int, withHeader header: UITableViewHeaderFooterView?) {
        
    }
    
    func tableView(tableView: FZAccordionTableView, didOpenSection section: Int, withHeader header: UITableViewHeaderFooterView?) {
        
    }
    
    func tableView(tableView: FZAccordionTableView, willCloseSection section: Int, withHeader header: UITableViewHeaderFooterView?) {
        
    }
    
    func tableView(tableView: FZAccordionTableView, didCloseSection section: Int, withHeader header: UITableViewHeaderFooterView?) {
        
    }
    
    func tableView(tableView: FZAccordionTableView, canInteractWithHeaderAtSection section: Int) -> Bool {
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
