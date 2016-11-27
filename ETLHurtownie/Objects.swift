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
//    public String toCSV (){
//    String drawbacksString = "";
//    for (RealmString string : drawbacks){
//    drawbacksString = drawbacksString + " " + string.toString();
//    }
//    
//    String advantagesString = "";
//    for (RealmString string : advantages){
//    advantagesString = advantagesString + " " + string.toString();
//    }
//    String csv = id + "," + drawbacksString.replace(",", ";") + "," + advantagesString.replace(",", ";") + "," + body.replace(",", ";") + "," + starsCount + "," + author.replace(",", ";") + "," + reviewDate + "," + recommend + "," + thumbUpCount + "," + thumbDownCount + "\n";
//    return csv;
//    }
    
//    public String toString() {
//    return "Review{" +
//    "\t" + "id=" + id + "\n" +
//    "\t" +", drawbacks=" + drawbacks +"\n" +
//    "\t" +", advantages=" + advantages +"\n" +
//    "\t" +", body='" + body + '\'' +"\n" +
//    "\t" +", starsCount=" + starsCount +"\n" +
//    "\t" +", author='" + author + '\'' +"\n" +
//    "\t" +", reviewDate=" + reviewDate +"\n" +
//    "\t" +", recommend=" + recommend +"\n" +
//    "\t" +", thumbUpCount=" + thumbUpCount +"\n" +
//    "\t" +", thumbDownCount=" + thumbDownCount +"\n" +
//    '}';
//    }
    
    func toString() -> String
    {
//        return "Review{" +
//            "\t" + "id=" + String(id) + "\n" +
//            "\t" + ", drawbacks=" + drawbacks + "\n" +
//            "\t" + ", advantages=" + advantages + "\n" +
//            "\t" + ", body='" + body + "'" + "\n" +
//            "\t" + ", starsCount=" + starsCount + "\n" +
//            "\t" + ", author='" + author + "'" + "\n" +
//            "\t" + ", reviewDate=" + reviewDate + "\n" +
//            "\t" + ", recommend=" + String(recomended) + "\n" +
//            "\t" + ", thumbUpCount=" + thumbUpCount + "\n" +
//            "\t" + ", thumbDownCount=" + thumbDownCount + "\n" +
//            "}"
        return ""
    }
    func toCSV() -> String
    {
        return ""
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
    
//    public String toCSV(){
//    String csv = "# Product data\n";
//    csv = csv + "# id produktu: " + id + "\n";
//    csv = csv + "# nazwa produktu: " + productName + "\n";
//    csv = csv + "# rodzaj: " + productType + "\n";
//    csv = csv + "# dodatkowy opis: " + additionalDescription + "\n";
//    csv = csv + "id opinii, wady, zalety, treść, ocena, autor, data opinii, polecany, +, -\n";
//    for (Review review : reviews){
//    csv = csv + review.toCSV();
//    }
//    return csv;
//    }
    func toCSV() -> String
    {
        var part1 = "# Product data\n:" + "#nazwa produktu: " + String(id) + "\n#rodzaj: " + productType + "\n#dodatkowy opis: " + additionalDescription + "\nid opinii, wady, zalety, treść, ocena, autor, data opinii, polecany, +, -\n"

        for reviewString in reviews
        {
            
        }
        
        
        return part1
        
    }

    func toTxt() -> String
    {
        return "id produktu: " + String(id) +
            "\nnazwa produktu: " + productName +
            "\nrodzaj: " + additionalDescription +
            "\ndodatkowy opis: " + additionalDescription + "\n"
    }
    
}
class RealmString: Object {
    dynamic var stringValue = ""
}
