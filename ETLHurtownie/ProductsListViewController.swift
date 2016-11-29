//
//  ReviewsViewController.swift
//  ETLHurtownie
//
//  Created by Kamil Walas on 19.11.2016.
//  Copyright © 2016 uek. All rights reserved.
//
import RealmSwift
import UIKit

/**
 Kontroler ekranu odpowiadającego za wyświetlanie produktów aktualnie będących w bazie danych
 */
class ProductsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    /**
     Widok listy w którym znajdują się recenzje
     */
    @IBOutlet weak var tableView: UITableView!
    
    /**
     Tablica produktów pobrana z bazy Realm - tablica ta jest przekazywana w widoku wcześniejszym
     */
    var products = [Product]()
    
    /**
     Wybrany index z tabeli który odpowiada za poprane przesłanie klikniętego produktu do kolejnego ekranu - ekranu szczegółów recenzji
     */
    var selectedIndex = Int()
    
    /**
     Funkcja przygotowująca ekran tuż po załadowaniu - ustawieni w niej zostają delegaci dla widoku listy oraz źródło danych za które odpowiada ta sama klasa oraz odpowiednie metody
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /**
     Funkcja zwracająca liczbę sekcji w tabeli
     
     Returns: ilość sekcji w tabeli
     */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    /**
     Funkcja zwracająca liczbę rekordów w tabeli
     
     Returns: ilość wierszy
     */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    /**
     Funkcja przygotowująca poszczególne wiersze
     
     Returns: wiersz tabeli
     */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("product", forIndexPath: indexPath) as!ProductsTableViewCell
        
        cell.productName.text = "Nazwa produktu: " + products[indexPath.row].productName
        cell.productType.text = "Typ produktu: " + products[indexPath.row].productType
        cell.productDescription.text = "Opis: " + products[indexPath.row].additionalDescription
        cell.productId.text = "ID produktu: " + String(products[indexPath.row].id)
        cell.productReviewsCount.text = "Opinie: " + String(products[indexPath.row].reviews.count)
        
        return cell
    }
    /**
     Funkcja odpowiadająca za akcję która się ma wydarzyć po kliknięciu poszczególnego wiersza tabeli
     */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        selectedIndex = indexPath.row
        performSegueWithIdentifier("showDetails", sender: nil)
    }
    /**
     Funkcja przygotowująca przejście do kolejnego ekranu - zostaje w niej przekazany odpowiedni element z tablicy produktów celem późniejszego wyświetlenia wszytkich recenzji
     */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetails"
        {
            let destination = segue.destinationViewController as! ProductDetailsViewController
            destination.product = products[selectedIndex]
        }
    }
}
