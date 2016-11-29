//
//  Objects.swift
//  ETLHurtownie
//
//  Created by Kamil Walas on 27.11.2016.
//  Copyright © 2016 ARIOS. All rights reserved.
//

import Foundation
import RealmSwift


class Review : Object
{
    dynamic var id = 0
    var drawbacks: [String] {
        get {
            return _backingDrawbacks.map { $0.stringValue }
        }
        set {
            _backingDrawbacks.removeAll()
            _backingDrawbacks.appendContentsOf(newValue.map({ RealmString(value: [$0]) }))
        }
    }
    let _backingDrawbacks = List<RealmString>()
    var advantages: [String] {
        get {
            return _backingAdvantages.map { $0.stringValue }
        }
        set {
            _backingAdvantages.removeAll()
            _backingAdvantages.appendContentsOf(newValue.map({ RealmString(value: [$0]) }))
        }
    }
    let _backingAdvantages = List<RealmString>()

    dynamic var body = ""
    dynamic var starsCount = 0.0
    dynamic var author = ""
    dynamic var reviewDate = NSDate()
    dynamic var recomended = false
    dynamic var thumbUpCount = 0
    dynamic var thumbDownCount = 0
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["drawbacks", "advantages"]
    }
    
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
    func toCSV(reviewString : String) -> String
    {
        let replaced = (reviewString as NSString).stringByReplacingOccurrencesOfString(",", withString: ":")
        return replaced
    }

}

class Product : Object
{
    dynamic var id = 0
    dynamic var productType = ""
    dynamic var productName = ""
    dynamic var additionalDescription = ""
    var reviews = List<Review>()

    override class func primaryKey() -> String? {
        return "id"
    }
    
    func toCSV() -> String
    {
        var part1 = "# Product data\n:" + "#nazwa produktu: " + String(id) + "\n#rodzaj: " + productType + "\n#dodatkowy opis: " + additionalDescription + "\n"
        for reviewString in reviews
        {
            part1 += reviewString.toCSV(reviewString.toString())
        }
        
        return part1
    }

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
class RealmString: Object {
    dynamic var stringValue = ""
}
