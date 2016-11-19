//
//  MainViewController.swift
//  ETLHurtownie
//
//  Created by Kamil Walas on 19.11.2016.
//  Copyright © 2016 ARIOS. All rights reserved.
//

import UIKit
import AZDropdownMenu
import Alamofire
import HTMLReader
//import Kanna

class MainViewController: UIViewController, UITextFieldDelegate {

    var menu : AZDropdownMenu?
    
    @IBOutlet weak var eProcessOutlet: UIButton!
    
    @IBOutlet weak var tProcessOutlet: UIButton!
    
    @IBOutlet weak var lProcessOutlet: UIButton!
    
    @IBOutlet weak var urlTextField: UITextField!
    
    @IBOutlet weak var logTextView: UITextView!
    
    let baseURL = "ceneo.pl"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareRoundedButton(eProcessOutlet)
        prepareRoundedButton(tProcessOutlet)
        prepareRoundedButton(lProcessOutlet)
        urlTextField.delegate = self
        logTextView.text = ""
        logTextView.font = UIFont(name: "HelveticaNeue-Light", size: 10)
        urlTextField.text = "40529315"
        let titles = ["Eksport CSV", "Eksport txt", "Wyczyść dane", "O aplikacji"]
        menu = AZDropdownMenu(titles: titles)
        let button = UIBarButtonItem(image: UIImage(named: "menu"), style: .Plain, target: self, action: #selector(MainViewController.showDropdown))
        
        navigationItem.rightBarButtonItem = button
        navigationItem.hidesBackButton = false
        navigationController?.navigationBar.translucent = false
        title = "ETL"
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        menu!.cellTapHandler = {  (indexPath: NSIndexPath) -> Void in
            print("Selected index: \(indexPath.row)")
            
            if indexPath.row == 3
            {
                self.performSegueWithIdentifier("showInfo", sender: nil)
            }
        }
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        textFieldOneLineBorder(urlTextField, color: UIColor.darkGrayColor())
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    func showDropdown() {
        if (self.menu?.isDescendantOfView(self.view) == true) {
            self.menu?.hideMenu()
        } else {
            self.menu?.showMenuFromView(self.view)
        }
    }

    @IBAction func eProcessAction(sender: AnyObject) {
        downloadReviews(baseURL, productID: "40529315")
    }
    
    @IBAction func tProcessAction(sender: AnyObject) {
    }
    
    @IBAction func lProcessAction(sender: AnyObject) {
    }
    
    func downloadReviews(baseURL : String, productID : String)
    {
        Alamofire.request(.POST, "http://ceneo.pl/\(productID)#tab-reviews").responseString(completionHandler: {response in
        
            if response.result.isSuccess
            {
                self.logTextView.text = response.description
//                if let html = response.result.value
//                {
//                   self.parseHTML(html)
//                }
                if let htmlAsString = response.result.value
                {
                    self.parseHTML(HTMLDocument(string: htmlAsString))
                }
            }
            else
            {
                self.logTextView.text = response.result.error?.localizedDescription
            }
            
        
        
        })
    }
    
//    func parseHTML(html : String)
//    {
//        if let doc = Kanna.HTML(html: html, encoding: NSUTF8StringEncoding){
//            
//            print(doc.title)
//            
//            for item in doc.css("pagination")
//            {
//                print(item.content)
//            }
//            
//        }
//        else
//        {
//            NSLog("NOPE")
//        }
//    }
    func parseHTML(html : HTMLDocument)
    {
        for item in html.nodesMatchingSelector("li")
        {
            for reviewer in (item.nodesMatchingParsedSelector(HTMLSelector(forString: "product_reviewer")))
            {
                print(reviewer)
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textFieldOneLineBorder(urlTextField, color: UIColor.redColor())
    }
    
    func textFieldOneLineBorder(textField : UITextField, color : UIColor)
    {
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = color.CGColor
        border.frame = CGRect(x: 0, y: urlTextField.frame.size.height - width, width:  urlTextField.frame.size.width, height: urlTextField.frame.size.height)
        border.borderWidth = width
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
    }
    func prepareRoundedButton(button : UIButton)
    {
        button.backgroundColor = UIColor.clearColor()
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.redColor().CGColor
    }

}


