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
import QuickLook

class MainViewController: UIViewController, UITextFieldDelegate, BusyAlertDelegate, QLPreviewControllerDataSource {

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
    
    var finalProduct = Product()
    
    let queue = dispatch_queue_create("realmQueue", DISPATCH_QUEUE_SERIAL)

    lazy var busyAlertController: BusyAlert = {
        let busyAlert = BusyAlert(title: "", message: "", presentingViewController: self)
        busyAlert.delegate = self
        return busyAlert
    }()
    
    var selectedOption = 0
    
    var quickLookController = QLPreviewController()
    
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
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        menu!.cellTapHandler = {  (indexPath: NSIndexPath) -> Void in
            print("Selected index: \(indexPath.row)")
            switch indexPath.row {
            case 0:
                print("eksport cvs")
                self.selectedOption = 0
                self.quickLookController = QLPreviewController()
                self.quickLookController.dataSource = self
                dispatch_async(dispatch_get_main_queue(), {
                    
                    let realm = try! Realm()
                    let productRealm = realm.objects(Product)
                    
                    var csvString = ""
                    for item in productRealm
                    {
                        csvString += item.toCSV() + "\n"
                    }
                    
                    if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
                        let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent("products.csv")
                        
                        //writing
                        do {
                            try csvString.writeToURL(path, atomically: false, encoding: NSUTF8StringEncoding)
                        }
                        catch {/* error handling here */}
                        
                        if QLPreviewController.canPreviewItem(path) {
                            self.quickLookController.currentPreviewItemIndex = 0
                            self.navigationController?.pushViewController(self.quickLookController, animated: true)
                        }
                    }
                })
                
            case 1:
                print("eksport txt")
                self.selectedOption = 1
                self.quickLookController = QLPreviewController()
                self.quickLookController.dataSource = self
                dispatch_async(dispatch_get_main_queue(), {
                    
                    let realm = try! Realm()
                    let productRealm = realm.objects(Product)
                    
                    var csvString = ""
                    for item in productRealm
                    {
                        csvString += item.toCSV() + "\n"
                    }
                    
                    if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
                        let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent("products.txt")
                        
                        //writing
                        do {
                            try csvString.writeToURL(path, atomically: false, encoding: NSUTF8StringEncoding)
                        }
                        catch {/* error handling here */}
                        
                        if QLPreviewController.canPreviewItem(path) {
                            self.quickLookController.currentPreviewItemIndex = 0
                            self.navigationController?.pushViewController(self.quickLookController, animated: true)
                        }
                    }
                })
            case 2:
                dispatch_async(dispatch_get_main_queue(), {
                    let realm = try! Realm()
                    try! realm.write {
                        realm.deleteAll()
                    }
                    self.removeFile("product", fileExtension: "txt")
                    self.removeFile("product", fileExtension: "csv")

                    dispatch_async(dispatch_get_main_queue(), {
                        let alert = UIAlertController(title: "Informacja", message: "Dane zostały usunięte", preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                        self.showResultsOutlet.enabled = false
                        self.showResultsOutlet.alpha = 0.2
                    
                    })
                })
                
            case 3:
                let alert = UIAlertController(title: "O Aplikacji", message: "ETL to aplikacja stworzona jako projekt zaliczeniowy z przedmiotu Hurtownie Danych na kierunku Informatyka Stosowana na Uniwersytecie Ekonomicznym w Krakowie. Głównym celem aplikacji jest przeprowadzenie procesu ETL (Extract, Transform, Load) na danych pobranych z serwisu Ceneo.pl\n\nAutorzy: Szymon Nitecki, Kamil Walas, Katarzyna Konopelska, Aleksandra Kołodziejczyk\n\nIcon made by Freepik from www.flaticon.com", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Zamknij", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)

            default:
                break
            }

        }
        dispatch_async(dispatch_get_main_queue(), {
                    let realm = try! Realm()
                    let product = realm.objects(Product)
            
                    if product.count > 0
                    {
                        self.showResultsOutlet.enabled = true
                        self.showResultsOutlet.alpha = 1
                    }
                    else
                    {
                        self.showResultsOutlet.enabled = false
                        self.showResultsOutlet.alpha = 0.2
                    }
        })
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
        urlTextField.resignFirstResponder()
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
        urlTextField.resignFirstResponder()
        busyAlertController = BusyAlert(title: "Trwa process proces Transform\n\n", message: "", presentingViewController: self)
        busyAlertController.display()
        logTextView.text = logTextView.text + "Rozpoczęto proces Transform\n"

        transformReviews(urlTextField.text!, automatic: false)
    }
    
    @IBAction func lProcessAction(sender: AnyObject) {
        urlTextField.resignFirstResponder()
        busyAlertController = BusyAlert(title: "Trwa process proces Load\n\n", message: "", presentingViewController: self)
        busyAlertController.display()
        logTextView.text = logTextView.text + "Rozpoczęto proces Load\n"

        loadDataProcess(finalProduct, automatic: false)
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

    var titleProduct = String()
    func transformReviews(productID : String, automatic : Bool)
    {
        let product = Product()
        let reviews = List<Review>()
        
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
                    let stringItem = item.objectForKeyedSubscript("content") as! String
                    product.productName = stringItem.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                }
                
                if item.objectForKeyedSubscript("property") as? String == "og:type"
                {
                    let stringItem = item.objectForKeyedSubscript("content") as! String
                    product.productType = stringItem.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())                }
                
                if item.objectForKeyedSubscript("property") as? String == "og:description"
                {
                    let stringItem = item.objectForKeyedSubscript("content") as! String
                    product.additionalDescription = stringItem.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
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
                                advan.append(pro.textContent.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()))
                            }
                        }
                        
                        if items.hasClass("cons-cell")
                        {
                            for con in items.nodesMatchingSelector("li")
                            {
                                drawb.append(con.textContent.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()))
                            }
                        }
                        
                        if items.hasClass("product-reviewer")
                        {
                            review.author = items.textContent.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
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
                                review.body = body.textContent.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
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
            finalProduct = product
            busyAlertController.dismiss()
            
        }
        else
        {
            loadDataProcess(product, automatic: true)
        }
    }

    func loadDataProcess(product : Product, automatic : Bool)
    {
        print(product.additionalDescription)
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
    var test = [Product]()
    @IBAction func showResultsAction(sender: AnyObject) {
        urlTextField.resignFirstResponder()
        dispatch_async(dispatch_get_main_queue(), {
            
            do
            {
                print(self.titleProduct)
                let realm = try Realm()
                let items = Array(realm.objects(Product))
                
                
                self.test = items
            }
            catch let error as NSError
            {
                print(error.localizedDescription)
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.performSegueWithIdentifier("showReviews", sender: nil)
            })
        })
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showReviews"
        {
            let destination = segue.destinationViewController as! ReviewsViewController
            destination.products = test
            
        }
    }
    @IBAction func performETL(sender: AnyObject) {
        urlTextField.resignFirstResponder()
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
    
    @IBAction func resignKeyboardAction(sender: AnyObject) {
        view.endEditing(true)
    }
    
    func numberOfPreviewItemsInPreviewController(controller: QLPreviewController) -> Int {
        return 1
    }

    func previewController(controller: QLPreviewController, previewItemAtIndex index: Int) -> QLPreviewItem {
        if selectedOption == 0
        {
            let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first
            
            let path = NSURL(fileURLWithPath: dir!).URLByAppendingPathComponent("products.csv")
            
            return path
        }
        else
        {
            let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first
            
            let path = NSURL(fileURLWithPath: dir!).URLByAppendingPathComponent("products.txt")
            
            return path
        }

    }
    
    func removeFile(itemName:String, fileExtension: String) {
        let fileManager = NSFileManager.defaultManager()
        let nsDocumentDirectory = NSSearchPathDirectory.DocumentDirectory
        let nsUserDomainMask = NSSearchPathDomainMask.UserDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        guard let dirPath = paths.first else {
            return
        }
        let filePath = "\(dirPath)/\(itemName).\(fileExtension)"
        do {
            try fileManager.removeItemAtPath(filePath)
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }

}


