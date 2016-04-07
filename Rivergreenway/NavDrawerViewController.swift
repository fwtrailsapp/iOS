//
//  NavDrawerViewController.swift
//  Rivergreenway
//
//  Created by Scott Weidenkopf on 2/9/16.
//  Copyright © 2016 City of Fort Wayne Greenways and Trails Department. All rights reserved.
//

import UIKit

/**
 Controls the Navigation Drawer. The navigation drawer includes the table containing the navigation
 items and the section containing the City seal and 311 reporting option.
 
 The nav drawer has a container view that is meant to contain the table as a separate table view
 controller (see NavDrawerTableViewController).
 
 */
class NavDrawerViewController: UIViewController, UIGestureRecognizerDelegate, NavTableDelegate {
    
    private var selectedCell: CellIdentifier = CellIdentifier.RecordActivityCell
    
    @IBOutlet weak var reportProblemLabel: UILabel!
    @IBOutlet weak var reportProblemImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addProblemReportingGestureRecognizers()
    }
    
    /**
     Programmatically adds gesture recognizers to the 'Report a Problem' label and
     the 'Call' icon such that they open the iPhone's dialer.
     */
    func addProblemReportingGestureRecognizers() {
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(NavDrawerViewController.openDialer))
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(NavDrawerViewController.openDialer))
        labelTap.delegate = self
        reportProblemImage.userInteractionEnabled = true
        reportProblemLabel.userInteractionEnabled = true
        
        reportProblemImage.addGestureRecognizer(imageTap)
        reportProblemLabel.addGestureRecognizer(labelTap)
    }
    
    /**
     Opens the phone's dialer and sets the dial number to 311. Note that this does not actually
     start the phone call.
     */
    func openDialer() {
        if let url = NSURL(string: "tel://311") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    /**
     Because the table view is contained in its own view controller, it is presented in the nav
     drawer via a segue. This method is called in preparation for that segue, and assigns this
     view controller as a delegate for the table view controller so that the table view controller
     can notify this view controller whenever its cells are pressed.
     */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let embeddedController = segue.destinationViewController as? NavDrawerTableViewController where segue.identifier == "NavDrawerTableSegue" {
            embeddedController.setDelegate(self)
        }
    }
    
    /**
     This method is part of the NavTableDelegate protocol (see NavDrawerTableViewController). Whenever a
     cell is pressed on the table, this method is called. It switches view controllers based on the
     cell that is pressed.
     */
    func cellPressed(cellID: CellIdentifier) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if cellID == selectedCell {
            appDelegate.drawerController!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            return
        }
        
        var newViewController: UIViewController?
        let mainStoryboard: UIStoryboard = UIStoryboard(name: ViewIdentifier.MAIN_STORYBOARD.rawValue, bundle: nil)
        
        
        switch(cellID) {
        case .RecordActivityCell:
            newViewController = mainStoryboard.instantiateViewControllerWithIdentifier(ViewIdentifier.RecordActivityNavController.rawValue)
            break
        case .ActivityHistoryCell:
            newViewController = mainStoryboard.instantiateViewControllerWithIdentifier(ViewIdentifier.ActivityHistoryNavController.rawValue)
            break
        case .AchievementsCell:
            newViewController = mainStoryboard.instantiateViewControllerWithIdentifier(ViewIdentifier.AchievementNavController.rawValue)
            break
        case .TrailMapCell:
            newViewController = mainStoryboard.instantiateViewControllerWithIdentifier(ViewIdentifier.TrailMapNavController.rawValue)
            break
        case .AccountStatisticsCell:
            newViewController = mainStoryboard.instantiateViewControllerWithIdentifier(ViewIdentifier.AccountStatisticsNavController.rawValue)
            break
        case .AccountDetailsCell:
            newViewController = mainStoryboard.instantiateViewControllerWithIdentifier(ViewIdentifier.AccountDetailsNavController.rawValue)
            break
        case .AboutCell:
            newViewController = mainStoryboard.instantiateViewControllerWithIdentifier(ViewIdentifier.AboutNavController.rawValue)
            break
        case .ExitCell:
            confirmLogOut()
            break
        }
        if newViewController != nil {
            
            // swap the center view controller of the nav drawer
            appDelegate.drawerController!.centerViewController = newViewController!
            selectedCell = cellID
        }
        
        // close the nav drawer once the view is swapped.
        appDelegate.drawerController!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
    }
    
    /**
     Displays an alert view asking users to confirm their decision to log out.
     */
    func confirmLogOut() {
        let alert = UIAlertController(title: "Log Out", message: "Are you sure you wish to log out?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: logOutHandler))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alert, animated: false, completion: nil)
    }
    
    func logOutHandler(action: UIAlertAction) {
        exit(0)
    }
}
