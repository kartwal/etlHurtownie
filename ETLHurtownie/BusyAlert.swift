//
//  BusyAlert.swift
//  ETLHurtownie
//
//  Created by Kamil Walas on 27.11.2016.
//  Copyright © 2016 uek. All rights reserved.
//
import Foundation
import UIKit
/**
 Klasa odpowiadająca za wyświetlanie ekranu oczekiwania - KLASA zaczerpnięta z INTERNETU - przeszła delikatne modyfikacje na potrzeby tej aplikacji
 */
class BusyAlert {
    
    /**
     Widok alertu
     */
    var busyAlertController: UIAlertController?
    
    /**
     Kontroller prezentujący
     */
    var presentingViewController: UIViewController?
    
    /**
     Indykator aktywności
     */
    var activityIndicator: UIActivityIndicatorView?
    
    /**
     Delegat dla alertu
     */
    var delegate:BusyAlertDelegate?
    /**
     Label inicjująca ekran oczekiwania
     
     Parameter title: tytuł wyświetlany pogrubioną czcionką
     Parameter message: wiadomość wyświetlana wąską czcionką
     Parameter presentingViewController: kontroler w którym chcemy wyświetlić widok oczekiwania
     */
    init (title:String, message:String, presentingViewController: UIViewController) {
        busyAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        self.presentingViewController = presentingViewController
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        busyAlertController!.view.addSubview(activityIndicator!)
    }
    /**
     Funkcja obsługująca włączenie ekranu oczekiwania
     */
    func display() {
        dispatch_async(dispatch_get_main_queue(), {
            self.presentingViewController!.presentViewController(self.busyAlertController!, animated: true, completion: {
                self.activityIndicator!.translatesAutoresizingMaskIntoConstraints = false
                self.busyAlertController!.view.addConstraint(NSLayoutConstraint(item: self.activityIndicator!, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.busyAlertController!.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
                self.busyAlertController!.view.addConstraint(NSLayoutConstraint(item: self.activityIndicator!, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.busyAlertController!.view, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0))
                self.activityIndicator!.startAnimating()
                
            })
        })
        
    }
    /**
     Funkcja obsługująca wyłączenie widoku oczekiwania
     */
    func dismiss() {
        dispatch_async(dispatch_get_main_queue(), {
            self.busyAlertController?.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    
}
/**
 Protokół odpowiadający za obsługę zdarzenia wyłączenia ekranu oczekiwania, funkcja MUSI zostać zaimplementowana, ale może być pusta.
 */
protocol BusyAlertDelegate {
    func didCancelBusyAlert()
}