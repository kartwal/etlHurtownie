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
import RealmSwift

class MainViewController: UIViewController, UITextFieldDelegate, BusyAlertDelegate {

    var menu : AZDropdownMenu?
    
    @IBOutlet weak var eProcessOutlet: UIButton!
    
    @IBOutlet weak var tProcessOutlet: UIButton!
    
    @IBOutlet weak var lProcessOutlet: UIButton!
    
    @IBOutlet weak var urlTextField: UITextField!
    
    @IBOutlet weak var logTextView: UITextView!
    
    @IBOutlet weak var etlProcessOutlet: UIButton!
    
    @IBOutlet weak var showResultsOutlet: UIButton!
    
    let baseURL = "http://ceneo.pl/"
    
    var downloadedHtmls = [HTMLDocument]()
    
    var product = Product()
    

    lazy var busyAlertController: BusyAlert = {
        let busyAlert = BusyAlert(title: "", message: "ETL to aplikacja stworzona jako projekt zaliczeniowy z przedmiotu Hurtownie Danych na kierunku Informatyka Stosowana na Uniwersytecie Ekonomicznym w Krakowie. Głównym celem aplikacji jest przeprowadzenie procesu ETL (Extract, Transform, Load) na danych pobranych z serwisu Ceneo.pl\n\nAutorzy: Szymon Nitecki, Kamil Walas, Katarzyna Konopelska, Aleksandra Kołodziejczyk\n\nIcon made by Freepik from www.flaticon.com", presentingViewController: self)
        busyAlert.delegate = self
        return busyAlert
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareRoundedButton(eProcessOutlet)
        prepareRoundedButton(tProcessOutlet)
        prepareRoundedButton(lProcessOutlet)
        prepareRoundedButton(showResultsOutlet)
        prepareRoundedButton(etlProcessOutlet)
        
        urlTextField.delegate = self
        logTextView.text = ""
        logTextView.font = UIFont(name: "HelveticaNeue-Light", size: 10)
        urlTextField.text = "45002653"
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
            switch indexPath.row {
            case 0:
                print("eksport cvs")
            case 1:
                print("eksport txt")
            case 2:
                let realm = try! Realm()
                try! realm.write {
                    realm.deleteAll()
                    let alert = UIAlertController(title: "Informacja", message: "Dane zostały usunięte", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            case 3:
                let alert = UIAlertController(title: "O Aplikacji", message: "", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Zamknij", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)

            default:
                break
            }

        }
        let realm = try! Realm()
        let person = realm.objects(Product)
        
        if person.count > 0
        {
            showResultsOutlet.enabled = true
            showResultsOutlet.alpha = 1
        }
        else
        {
            showResultsOutlet.enabled = false
            showResultsOutlet.alpha = 0.2
        }
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
        downloadedHtmls.removeAll()
        busyAlertController = BusyAlert(title: "Trwa process Extract\n\n", message: "", presentingViewController: self)
        busyAlertController.display()
        logTextView.text = logTextView.text + "Rozpoczęto proces Extract\n"
        if let typedId = urlTextField.text
        {
            downloadReviews(baseURL, productID: typedId, automatic: false)

        }
        else
        {
            downloadReviews(baseURL, productID: "", automatic: false)
        }
        
    }
    
    @IBAction func tProcessAction(sender: AnyObject) {
        busyAlertController = BusyAlert(title: "Trwa process proces Transform\n\n", message: "", presentingViewController: self)
        busyAlertController.display()
        logTextView.text = logTextView.text + "Rozpoczęto proces Transform\n"
        
        transformReviews(urlTextField.text!, automatic: false)
    }
    
    @IBAction func lProcessAction(sender: AnyObject) {
        busyAlertController = BusyAlert(title: "Trwa process proces Load\n\n", message: "", presentingViewController: self)
        busyAlertController.display()
        logTextView.text = logTextView.text + "Rozpoczęto proces Load\n"
        
        loadDataProcess(product, automatic: false)
    }
    
    func downloadReviews(baseURL : String, productID : String, automatic : Bool)
    {
        Alamofire.request(.POST, "\(baseURL)\(productID)").responseString(completionHandler: {response in
            if response.result.isSuccess
            {
                if let htmlAsString = response.result.value
                {
                    self.parseHTML(HTMLDocument(string: htmlAsString), automatic: automatic)
                }
            }
            else
            {
                self.logTextView.text = "❌" + (response.result.error?.localizedDescription)!
            }
        })
    }
    
    func parseHTML(html : HTMLDocument, automatic : Bool)
    {
        downloadedHtmls.append(html)
        var nextPage = String?()
        let div = html.nodesMatchingSelector("div")
        
        for item in div{
            
            if item.hasClass("pagination")
            {
                for link in item.nodesMatchingSelector("li")
                {
                    if link.hasClass("arrow-next")
                    {
                        nextPage = link.firstNodeMatchingSelector("a")?.objectForKeyedSubscript("href") as? String
                        print(nextPage)
                        if automatic == false
                        {
                            downloadReviews(baseURL, productID: nextPage!, automatic: false)
                        }
                        else
                        {
                            downloadReviews(baseURL, productID: nextPage!, automatic: true)
                        }
                        
                    }
                }
            }
        }
        
        if nextPage == nil
        {
            if downloadedHtmls.count == 1
            {
                logTextView.text = logTextView.text + "✅ Zakończono proces Extract\n⬇️Pobrany został \(downloadedHtmls.count) plik\n"
            }
            else
            {
                logTextView.text = logTextView.text + "✅ Zakończono proces Extract\n⬇️Pobranych zostało \(downloadedHtmls.count) plików\n"
            }
            
            if automatic == false
            {
                tProcessOutlet.enabled = true
                tProcessOutlet.alpha = 1
                busyAlertController.dismiss()
            }
            else{
                if let typedId = urlTextField.text
                {
                    transformReviews(typedId, automatic: true)

                    
                }
                else
                {
                    transformReviews("", automatic: true)

                }
            }
        }
    }

    
    func transformReviews(productID : String, automatic : Bool)
    {
        var reviews = List<Review>()
        
        if productID == ""
        {
            product.id = 0
        }
        else
        {
           product.id = Int(productID)!
        }
        
        
        if downloadedHtmls.count > 0
        {
            let document = downloadedHtmls[0]
            for item in document.nodesMatchingSelector("meta"){
                
                if item.objectForKeyedSubscript("property") as? String == "og:title"
                {
                    product.productName = item.objectForKeyedSubscript("content") as! String
                }
                
                if item.objectForKeyedSubscript("property") as? String == "og:type"
                {
                    product.productName = item.objectForKeyedSubscript("content") as! String
                }
                
                if item.objectForKeyedSubscript("property") as? String == "og:description"
                {
                    product.productName = item.objectForKeyedSubscript("content") as! String
                }
            }
        }
        
        for site in downloadedHtmls
        {
            let div = site.nodesMatchingSelector("li")
            
            for item in div
            {
                if item.hasClass("product-review")
                {
                    let review = Review()
                    var advan = [String]()
                    var drawb = [String]()
                    var isFirst = false
                    
                    for butt in item.nodesMatchingSelector("button")
                    {
                        if butt.hasClass("vote-yes")
                        {
                            review.id = Int((butt.objectForKeyedSubscript("data-review-id")?.intValue)!)
                            review.thumbUpCount = Int((butt.firstNodeMatchingSelector("span")?.textContent)!)!
                        }
                        
                        if butt.hasClass("vote-no")
                        {
                            review.thumbDownCount = Int((butt.firstNodeMatchingSelector("span")?.textContent)!)!
                             print("OCENA", butt.firstNodeMatchingSelector("span")?.textContent)
                        }
                    }
                    
                    for items in item.nodesMatchingSelector("div")
                    {
                        if items.hasClass("pros-cell")
                        {
                            for pro in items.nodesMatchingSelector("li")
                            {
                                print(pro.textContent)
                                advan.append(pro.textContent)
                            }
                        }
                        
                        if items.hasClass("cons-cell")
                        {
                            for con in items.nodesMatchingSelector("li")
                            {
                                drawb.append(con.textContent)
                            }
                        }
                        
                        if items.hasClass("product-reviewer")
                        {
                            review.author = items.textContent
                        }
                        
                        for span in items.nodesMatchingSelector("span")
                        {
                            if span.hasClass("review-score-count")
                            {
                                let delimiter = "/"
                                let number = span.textContent
                                let splits = number.componentsSeparatedByString(delimiter)
                                
                                let splitSecond = splits.first?.componentsSeparatedByString(",")
                                review.starsCount = Double((splitSecond?.first)! + "." + (splitSecond?.last)!)!
                            }
                        }
                        
                        for body in items.nodesMatchingSelector("p")
                        {
                            if body.hasClass("product-review-body") && isFirst == false
                            {
                                print(body.textContent)
                                review.body = body.textContent
                                let dateFormatter = NSDateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                review.reviewDate = dateFormatter.dateFromString(item.firstNodeMatchingSelector("time")?.objectForKeyedSubscript("datetime") as! String)!
                                isFirst = true
                            }
                        }
                        
                        if let rec = items.firstNodeMatchingSelector("em")?.textContent
                        {
                            if rec == "Polecam"
                            {
                                review.recomended = true
                            }
                            else
                            {
                                review.recomended = false
                            }
                        }
                    }
                    review.advantages = advan
                    review.drawbacks = drawb
                    reviews.append(review)
                }
            }
        }
        
        product.reviews = reviews
        logTextView.text = logTextView.text + "✅Zakończono proces Transform\n✳️Dodano \(reviews.count) opinii\n"
        
        if automatic == false
        {
            tProcessOutlet.enabled = false
            tProcessOutlet.alpha = 0.2
            lProcessOutlet.enabled = true
            lProcessOutlet.alpha = 1
            busyAlertController.dismiss()
            
        }
        else
        {
            loadDataProcess(product, automatic: true)
        }
    }

    func loadDataProcess(product : Product, automatic : Bool)
    {
        let realm = try! Realm()        
        do{
            try realm.write{
                realm.create(Product.self, value: product, update: true)
            }
        }catch let error as NSError
        {
            print(error.localizedDescription)
        }
        
        
        if automatic == false{
            showResultsOutlet.enabled = true
            showResultsOutlet.alpha = 1
            lProcessOutlet.enabled = false
            lProcessOutlet.alpha = 0.2
            logTextView.text = logTextView.text + "✅Zakończono proces Load\n"
            busyAlertController.dismiss()
        }
        else
        {
            showResultsOutlet.enabled = true
            showResultsOutlet.alpha = 1
            lProcessOutlet.enabled = false
            lProcessOutlet.alpha = 0.2
            logTextView.text = logTextView.text + "✅Zakończono proces Load\n"
            logTextView.text = logTextView.text + "✅Zakończono proces ETL\n"
            busyAlertController.dismiss()
        }
    }
    
    @IBAction func showResultsAction(sender: AnyObject) {
        performSegueWithIdentifier("showReviews", sender: nil)
    }
    @IBAction func performETL(sender: AnyObject) {
        lProcessOutlet.enabled = false
        lProcessOutlet.alpha = 0.2
        tProcessOutlet.enabled = false
        tProcessOutlet.alpha = 0.2
        logTextView.text = logTextView.text + "Rozpoczęto proces ETL\n"
        busyAlertController = BusyAlert(title: "Trwa process ETL\n\n", message: "", presentingViewController: self)
        busyAlertController.display()
        downloadedHtmls.removeAll()
        downloadReviews(baseURL, productID: urlTextField.text!, automatic: true)

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
    
    func didCancelBusyAlert() {
        
    }
    
    

}


