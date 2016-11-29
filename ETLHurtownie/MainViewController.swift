//
//  MainViewController.swift
//  ETLHurtownie
//
//  Created by Kamil Walas on 19.11.2016.
//  Copyright © 2016 uek. All rights reserved.
//

import UIKit
import AZDropdownMenu
import Alamofire
import HTMLReader
import RealmSwift
import QuickLook

class MainViewController: UIViewController, UITextFieldDelegate, BusyAlertDelegate, QLPreviewControllerDataSource {

    /**
     Obiekt menu typu dropdown - spadającego z góry ekranu
     */
    var menu : AZDropdownMenu?
    
    /**
     Outlet dla przycisku
     */
    @IBOutlet weak var eProcessOutlet: UIButton!
    /**
     Outlet dla przycisku
     */
    @IBOutlet weak var tProcessOutlet: UIButton!
    /**
     Outlet dla przycisku
     */
    @IBOutlet weak var lProcessOutlet: UIButton!
    /**
     Outlet dla pola tekstowego
     */
    @IBOutlet weak var urlTextField: UITextField!
    /**
     Outlet dla pwidoku tekstowego
     */
    @IBOutlet weak var logTextView: UITextView!
    /**
     Outlet dla przycisku
     */
    @IBOutlet weak var etlProcessOutlet: UIButton!
    /**
     Outlet dla przycisku
     */
    @IBOutlet weak var showResultsOutlet: UIButton!
    /**
     Bazowy element linku który jest wykorzysytywany przy przesyłaniu żądania na serwer ceneo
     */
    let baseURL = "http://ceneo.pl/"
    /**
     Tablica przechowująca pobrane strony html
     */
    var downloadedHtmls = [HTMLDocument]()
    /**
    Finalny obiekt produktu używany przy automatycznym procesie ETL
     */
    var finalProduct = Product()
    /**
     Inicjalizacja kontrolera będącego widokiem który jest prezentowany przy oczekiwaniu na skończenie np pobierania
     */
    lazy var busyAlertController: BusyAlert = {
        let busyAlert = BusyAlert(title: "", message: "", presentingViewController: self)
        busyAlert.delegate = self
        return busyAlert
    }()
    /**
     Zmienna przechowująca wartość wybranego pliku do odczytu
     */
    var selectedOption = 0
    /**
     Obiekt quick-look odpowiadający za wywietlanie pliku txt bądź csv
     */
    var quickLookController = QLPreviewController()
    
    /**
     Funkcja przygotowująca ekran tuż po załadowaniu - określa akcje dla menu, ustala kształt przycisków, ustawia delegata dla pola tekstowego oraz sprawdza początkowy stan bazy
     */
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
    /**
     Funkcja ustawiająca layout po załadowaniu wszystkich pod-widoków oraz komponentów
     */
    override func viewDidLayoutSubviews() {
        textFieldOneLineBorder(urlTextField, color: UIColor.darkGrayColor())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /**
     Funkcja odpowiadająca za pokazanie menu
     */
    func showDropdown() {
        if (self.menu?.isDescendantOfView(self.view) == true) {
            self.menu?.hideMenu()
        } else {
            self.menu?.showMenuFromView(self.view)
        }
    }
    /**
     Funkcja odpowiadająca za obsługę przycisku "E" - jej outlet action
     */
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
    /**
     Funkcja odpowiadająca za obsługę przycisku "T" - jej outlet action
     */
    @IBAction func tProcessAction(sender: AnyObject) {
        urlTextField.resignFirstResponder()
        busyAlertController = BusyAlert(title: "Trwa process proces Transform\n\n", message: "", presentingViewController: self)
        busyAlertController.display()
        logTextView.text = logTextView.text + "Rozpoczęto proces Transform\n"

        transformReviews(urlTextField.text!, automatic: false)
    }
    /**
     Funkcja odpowiadająca za obsługę przycisku "l" - jej outlet action
     */
    @IBAction func lProcessAction(sender: AnyObject) {
        urlTextField.resignFirstResponder()
        busyAlertController = BusyAlert(title: "Trwa process proces Load\n\n", message: "", presentingViewController: self)
        busyAlertController.display()
        logTextView.text = logTextView.text + "Rozpoczęto proces Load\n"

        loadDataProcess(finalProduct, automatic: false)
    }
    /**
     Funkcja odpowiadająca za wysłanie zapytania na serwer oraz przekazanie obsługi do dalszej funkcji - parseHTML
     
     Parameter baseURL: pierwsza część linku do ceneo
     Parameter productID: id produktu którego recenzje chcemy odczytać
     Parameter automatic: bool mówiący czy akcja toczy się z przycisku E czy z przycisku ETL
     */
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
    /**
     Funkcja parsująca HTML
     
     Parameter html: dokument html ściągnięty z internetu
     Parameter automatic: bool mówiący czy akcja toczy się z przycisku E czy z przycisku ETL
     */
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

    /**
     Funkcja odpowiadająca za transformacje danych pobranych z HTML'a
     
     Parameter productID: id podane przez użytkownika
     Parameter automatic: zmienna oznaczająca czy akcja pochodzi z przycisku T czy z ETL
     */
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
           if let typedId = Int(productID)
           {
                product.id = typedId
           }
           else
           {
                product.id = 0
           }
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
    /**
     Funkcja odpowiadająca za załadownie danych do bazy danych Realm
     
     Parameter product: obiekt produktu
     Parameter automatic: bool sygnalizujący czy akcja pochodzi z przycisku L czy z przycisku ETL
     */
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
    /**
    Zmienna w której zostają przesłane dane do dalszego widoku
     */
    var productsFin = [Product]()
    /**
     Funkcja odpowiadająca za obsługę przycisku "Pokaż wyniki"
     */
    @IBAction func showResultsAction(sender: AnyObject) {
        urlTextField.resignFirstResponder()
        dispatch_async(dispatch_get_main_queue(), {
            
            do
            {
                let realm = try Realm()
                let items = Array(realm.objects(Product))
                
                
                self.productsFin = items
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
    /**
     Funkcja przygotowująca przejście na kolejny ekran
     */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showReviews"
        {
            let destination = segue.destinationViewController as! ProductsListViewController
            destination.products = productsFin
            
        }
    }
    /**
     Funkcja odpowiadająca za obsługę przycisku "ETL" - jej outlet action
     */
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
    /**
     Funkcja delegująca zachowanie klawiatury wywołaniu akcji zamknięcia klawiatury
     */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    /**
     Funkcja odpowiadająca zdarzenie rozpoczęcia edytowania pola tekstowego
     */
    func textFieldDidBeginEditing(textField: UITextField) {
        textFieldOneLineBorder(urlTextField, color: UIColor.redColor())
    }
    /**
     Funkcja odpowiadająca za rysowanie "androidowej" lini w polu tekstowym
     
     Parameter textField: pole które chcemy obrysować
     Parameter color: kolor który chcemy nadać
     */
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
    
    /**
     Funkcja odpowiadająca za narysowanie prostokątnego outline'a dla przycisku
     
     Parameter button: przycisk który chcemy obrysować
     */
    func prepareRoundedButton(button : UIButton)
    {
        button.backgroundColor = UIColor.clearColor()
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.redColor().CGColor
    }
    /**
     Funkcja wymagana do poprawnego działania wioku oczekiwania - nie ma zdefiniowanego żadnego działania specjalnego które ma się wykonać po zamknięciu alertu
     */
    func didCancelBusyAlert() {
        
    }
    /**
     Akcja przycisku zamykającego klawiaturę - jest to przycisk globalny - całoekranowy
     */
    @IBAction func resignKeyboardAction(sender: AnyObject) {
        view.endEditing(true)
    }
    /**
     Metoda odpowiedzialna za obsługę podglądu pliku zwracająca ilość przeglądanych plików "na raz" - funkcja delegująca
     */
    func numberOfPreviewItemsInPreviewController(controller: QLPreviewController) -> Int {
        return 1
    }
    /**
     Funkcja odpowiadająca za to który plik ma zostać odczytany - funkcja delegująca
     */
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
    /**
     Funkcja odpowiadająca za usuwanie plików
     
     Parameter itemName: nazwa pliku
     Parameter fileExtension: rozszerzenie pliku
     */
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


