//
//  ProductDetailsViewController.swift
//  ETLHurtownie
//
//  Created by Kamil Walas on 28.11.2016.
//  Copyright © 2016 uek. All rights reserved.
//

import UIKit
/**
 Kontorler ekranu recenzji
 */
class ProductDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, BusyAlertDelegate {

    /**
     Lista w której są wyświetlane recenzje
     */
    @IBOutlet weak var tableView: UITableView!
    /**
     Obiekt produktu
     */
    var product = Product()
    
    /**
     String zawierający wszystkie informacje które będą wyświetlone w pojedyńczym wierszu
     */
    var reviewString = ""
    /**
     Inicjalizacja kontrolera będącego widokiem który jest prezentowany przy oczekiwaniu na skończenie np pobierania
     */
    lazy var busyAlertController: BusyAlert = {
        let busyAlert = BusyAlert(title: "", message: "", presentingViewController: self)
        busyAlert.delegate = self
        return busyAlert
    }()
    /**
     Funkcja przygotowująca ekran
     */
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    /**
     Funkcja wykonująca się po pojawieniu ekranu - po załadowaniu - wyłącza ona ekran ładowania oraz ustawia delegat dla tablicy oraz dataSource
     */
    override func viewDidAppear(animated: Bool) {
        busyAlertController = BusyAlert(title: "Trwa ładowanie danych\n\n", message: "", presentingViewController: self)
        busyAlertController.display()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData({
        
            self.busyAlertController.dismiss()
        
        })
    }
    /**
     Funkcja delegata tabeli - zwraca ilość sekcji - jeśli nie ma opinii to funkcja ustawia odpowiedni komunikat na ekranie
     
     Returns: ilość sekcji
     */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if product.reviews.count > 0
        {
            tableView.separatorStyle = .SingleLine
            numOfSections                = 1
            tableView.backgroundView = nil
        }
        else
        {
            let noDataLabel: UILabel     = UILabel(frame: CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height))
            noDataLabel.text             = "Brak opinii"
            noDataLabel.textColor        = UIColor.blackColor()
            noDataLabel.textAlignment    = .Center
            tableView.backgroundView = noDataLabel
            tableView.separatorStyle = .None
        }
        return numOfSections
    }
    /**
     Funkcja delegata tabeli - zwraca ilość rekordów w sekcji
     
     Returns: ilość wierszy na podstawie ilość recenzji - jeśli recenzji jest 0 zwraca pustą tablicę
     */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return product.reviews.count
    }
    /**
     Funkcja delegata tabeli - zwraca pojedyńczy rekord
     
     Returns: pojedyńczy wiersz tabeli
     */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("review", forIndexPath: indexPath) as! ReviewTableViewCell
        cell.reviewText.text = reviewString
        cell.reviewText.sizeThatFits(cell.frame.size)
        cell.reviewText.scrollEnabled = true
        cell.reviewText.scrollEnabled = false
        return cell
    }
    /**
     Funkcja delegata tabeli - zwraca wysokość dla poszczególnych wierszy tabeli na podstawie (w tym wypadku) contentu umieszczonego wewnątrz widoku tekstu, w tym wypadku funkcja ta odpowiada również za uzupełnienie String'a z danymi. Ta funkcja jest wywoływana PRZED funkcją zwracającą wiersz tabeli
     
     Returns: wysokość wiersza
     */
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        reviewString = ""
        
        reviewString += "Autor opinii: " + product.reviews[indexPath.row].author + "\n\n"

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        reviewString += "Data opinii: " + dateFormatter.stringFromDate(product.reviews[indexPath.row].reviewDate) + "\n\n"

        reviewString += "Rekomendacja: " + String(product.reviews[indexPath.row].recomended) + "\n\n"
        
        reviewString += "Ocena użytkownika: " + String(product.reviews[indexPath.row].starsCount) + "\n\n"
        
        reviewString += "Opinia:\n " + product.reviews[indexPath.row].body
        if product.reviews[indexPath.row].advantages.count > 0
        {
            reviewString += "\n\nZalety: \n"
            for item in product.reviews[indexPath.row].advantages
            {
                reviewString += item + "\n"
            }
        }
        reviewString += "\n\n"
        
        if product.reviews[indexPath.row].advantages.count > 0
        {
            reviewString += "Wady: \n"
            for item in product.reviews[indexPath.row].drawbacks
            {
                reviewString += item + "\n"
            }
        }
        reviewString += "\n\n" + "Oceny pozytywne komentarza: " + String(product.reviews[indexPath.row].thumbUpCount)
        reviewString += "\n\n" + "Oceny negatywne komentarza: " + String(product.reviews[indexPath.row].thumbDownCount)

        print(reviewString)
        let testView = UITextView()
        testView.text = reviewString
        testView.font = UIFont.systemFontOfSize(15)
        let screenBounds = UIScreen.mainScreen().bounds
        let size = screenBounds.size
        let sizeNew = testView.sizeThatFits(CGSizeMake(size.width - 15, CGFloat(FLT_MAX)))

        return sizeNew.height

    }
    /**
     Funkcja wymagana do poprawnego działania wioku oczekiwania - nie ma zdefiniowanego żadnego działania specjalnego które ma się wykonać po zamknięciu alertu
     */
    func didCancelBusyAlert() {
        
    }
}

/**
 Rozszerzenie dla tableView umożliwiające wykonanie akcji po przeładowaniu danych
 */
extension UITableView {
    func reloadData(completion: ()->()) {
        UIView.animateWithDuration(0, animations: { self.reloadData() })
        { _ in completion() }
    }
}