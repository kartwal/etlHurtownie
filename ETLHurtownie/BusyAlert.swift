//
//  BusyAlert.swift
//  ETLHurtownie
//
//  Created by Kamil Walas on 27.11.2016.
//  Copyright © 2016 ARIOS. All rights reserved.
//
import Foundation
import UIKit

class BusyAlert {
    
    var busyAlertController: UIAlertController?
    var presentingViewController: UIViewController?
    var activityIndicator: UIActivityIndicatorView?
    var delegate:BusyAlertDelegate?
    
    init (title:String, message:String, presentingViewController: UIViewController) {
        busyAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
//        busyAlertController!.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel Button"), style: UIAlertActionStyle.Cancel, handler:{(alert: UIAlertAction!) in
//            self.delegate?.didCancelBusyAlert()
//        }))
        self.presentingViewController = presentingViewController
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        busyAlertController!.view.addSubview(activityIndicator!)
    }
    
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
    
    func dismiss() {
        dispatch_async(dispatch_get_main_queue(), {
            self.busyAlertController?.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    
}

protocol BusyAlertDelegate {
    func didCancelBusyAlert()
}