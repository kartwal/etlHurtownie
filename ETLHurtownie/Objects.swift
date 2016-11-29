//
//  Objects.swift
//  ETLHurtownie
//
//  Created by Kamil Walas on 27.11.2016.
//  Copyright © 2016 uek. All rights reserved.
//

import Foundation
import RealmSwift

/**
 Obiekt reprezentujący Recenzje pobraną ze strony ceneo.pl
 */
class Review : Object
{
    /**
     id Recenzji
     */
    dynamic var id = 0
    /**
     Wady produktu wymienione w recenzji
     */
    var drawbacks: [String] {
        get {
            return _backingDrawbacks.map { $0.stringValue }
        }
        set {
            _backingDrawbacks.removeAll()
            _backingDrawbacks.appendContentsOf(newValue.map({ RealmString(value: [$0]) }))
        }
    }
    /**
     Obiekt służący do mapowania listy wad z bazy Realm
     */
    let _backingDrawbacks = List<RealmString>()
    /**
     Zalety produktu wymienione w recenzji
     */
    var advantages: [String] {
        get {
            return _backingAdvantages.map { $0.stringValue }
        }
        set {
            _backingAdvantages.removeAll()
            _backingAdvantages.appendContentsOf(newValue.map({ RealmString(value: [$0]) }))
        }
    }
    /**
     Obiekt służący do mapowania listy zalet z bazy Realm
     */
    let _backingAdvantages = List<RealmString>()

    /**
     Treść recenzji
     */
    dynamic var body = ""
    /**
    Licznik gwiazdek
     */
    dynamic var starsCount = 0.0
    /**
     Autor recenzji
     */
    dynamic var author = ""
    /**
     Data zamieszczenia recenzji
     */
    dynamic var reviewDate = NSDate()
    /**
     Wartość reprezentująca czy produkt jest poleceany przez użytkownika
     */
    dynamic var recomended = false
    /**
     Licznik łapek w górę
     */
    dynamic var thumbUpCount = 0
    /**
     Licznik łapek w dół
     */
    dynamic var thumbDownCount = 0
    
    /**
     Funkcja zwracająca klucz główny tabeli
     */
    override class func primaryKey() -> String? {
        return "id"
    }
    /**
     Funkcja zwracająca igonorowane elementy dla obsługi bazy Realm
     */
    override static func ignoredProperties() -> [String] {
        return ["drawbacks", "advantages"]
    }
    /**
     Metoda przekształcająca obiekt recenzji do ciągu znakowego
     
     Returns: Ciąg znaków reprezentujący recenzje
     */
    func toString() -> String
    {
        var drawbacksString = ""
        for item in drawbacks
        {
            drawbacksString += item + ","
        }
        var advantagesString = ""
        for item in advantages
        {
            advantagesString += item + ","
        }
        
            var stringReview = "Review{" + "\t" + "id=" + String(id) + "\n" + "\t" + ", drawbacks=" + drawbacksString + "\n" +
                "\t" + ", advantages=" + advantagesString + "\n" +
                "\t" + ", body='" + body + "'" + "\n"
                "\t, starsCount= \(starsCount)"
    
            stringReview += "\n" +
                "\t" + ", author='" + author + "'" + "\n" +
                "\t" + ", reviewDate=" + String(reviewDate) + "\n" +
                "\t" + ", recommend=" + String(recomended) + "\n"

            stringReview += "\t" + ", thumbUpCount=" + String(thumbUpCount) + "\n"
        
            stringReview += "\t" + ", thumbDownCount=" + String(thumbDownCount) + "\n"
        
            return stringReview
    
    }
    /**
     Eksport recenzji do formatu pliku CSV
     
     Returns: ciąg znaów z formatowaniem odpowiednim dla pliku CSV
     */
    func toCSV(reviewString : String) -> String
    {
        let replaced = (reviewString as NSString).stringByReplacingOccurrencesOfString(",", withString: ":")
        return replaced
    }

}
/**
 Wady produktu wymienione w recenzji
 */
class Product : Object
{
    /**
     Id produktu
     */
    dynamic var id = 0
    /**
     Typ produktu
     */
    dynamic var productType = ""
    /**
     Nazwa produktu
     */
    dynamic var productName = ""
    /**
     Opis produktu
     */
    dynamic var additionalDescription = ""
    /**
     Lista obiektów typu Review przypisanych do produktu
     */
    var reviews = List<Review>()

    /**
    Funkcja zwracająca klucz główny
     */
    override class func primaryKey() -> String? {
        return "id"
    }
    
    /**
     Funkcja przekształcająca obiekt Product do formatu ciągu znaków CSV
     
     Returns: Ciąg znaków będący odpowiednim ciągiem dla jednego produktu w formatowaniu zgodnym z formatem CSV
     */
    func toCSV() -> String
    {
        var part1 = "# Product data\n:" + "#nazwa produktu: " + String(id) + "\n#rodzaj: " + productType + "\n#dodatkowy opis: " + additionalDescription + "\n"
        for reviewString in reviews
        {
            part1 += reviewString.toCSV(reviewString.toString())
        }
        
        return part1
    }
    /**
     Funkcja przekształcająca obiektu Produktu do ciągu znakowego który zostanie zapisany w pliku txt
     
     Returns: Ciąg znaków
     */
    func toTxt() -> String
    {
        var part1 = "Opinia: "
        for reviewString in reviews
        {
            part1 += reviewString.toString()
        }
        return "id produktu: " + String(id) +
            "\nnazwa produktu: " + productName +
            "\nrodzaj: " + additionalDescription +
            "\ndodatkowy opis: " + additionalDescription + "\n" + part1 + "\n\n\n"
    }
    
}
/**
 Klasa pomocnicza dla obsługi ciągów znaków w Realm - klasa ta pozwala na późniejsze przekształcanie tablic na elementy listy zgodne z Realm
 */
class RealmString: Object {
    dynamic var stringValue = ""
}
