//
//  ViewController.swift
//  LyftTrip
//
//  Created by Byron Warner on 1/16/16.
//  Copyright © 2016 Byron Warner. All rights reserved.
//

import UIKit
import CoreLocation

class TripHistoryController: UITableViewController, TripManagerDelegate, CLLocationManagerDelegate  {

    var tripDao:TripDao = TripMemoryDao()
    var trips:[Trip]?
    var logLocation:Bool = false
    var manager:CLLocationManager?
    var tripManager:TripManager?
    var lastAuthorizationStatus:CLAuthorizationStatus?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = TripHistoryTitleView(frame: CGRectMake(0,0, 640/2, 89/2))
        manager = CLLocationManager()
        tripManager = TripManager(tripDao: tripDao)
        if let tripManager = tripManager {
            tripManager.delegate = self
            manager?.delegate = tripManager
        }
        manager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        manager?.distanceFilter = 10
        NSNotificationCenter.defaultCenter().addObserver(self, selector:Selector("applicationEnteredForeground"), name:UIApplicationWillEnterForegroundNotification, object:nil);
//        NSNotificationCenter.defaultCenter().addObserver(self, selector:Selector("applicationDidBecomeActiveNotification"), name:UIApplicationDidBecomeActiveNotification, object:nil);

        trips = tripDao.findAll()
    }
    
    override func viewWillDisappear(animated:Bool) {
         NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        setupLocationManager()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else {
            return trips?.count ?? 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell =  tableView.dequeueReusableCellWithIdentifier("ToggleLoggingCell")!
            if let toggleCell = cell as? ToggleLoggingCell {
                toggleCell.toggleLogging.setOn(logLocation, animated:false)
                toggleCell.toggleLogging.addTarget(self, action: Selector("didToggleLogging:"), forControlEvents: UIControlEvents.ValueChanged)
                
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("TripCell")
            if let tripCell = cell, trip = trips?[indexPath.row] {
                tripCell.textLabel!.text = trip.route
                tripCell.detailTextLabel!.text = trip.duration ?? "No Duration"
            }
            return cell!
        }
    }
    
    func checkLoggingSwitch() {
        if (logLocation) {
            manager?.startUpdatingLocation()
        }
        else {
            manager?.stopUpdatingLocation()
        }
    }
    
    // MARK: - Actions
    func didToggleLogging(sender:UISwitch) {
        NSLog("switch is \(sender.on)")
        self.logLocation = sender.on
        checkLoggingSwitch()
    }
    
    func setupLocationManager() {
        
        let currentAuthorizationStatus = CLLocationManager.authorizationStatus()
        
        if let manager = manager  {
            switch CLLocationManager.authorizationStatus() {
            case .NotDetermined:
                manager.requestAlwaysAuthorization()
//                manager.startUpdatingLocation()
            case .Denied:
                showLocationWarning()
            case .Restricted:
                showLocationWarning()
            default:
                NSLog("Location Services are ok")
                checkLoggingSwitch()
            }
        }
        lastAuthorizationStatus = currentAuthorizationStatus
    }
    
    func applicationEnteredForeground() {
        setupLocationManager()
        refreshTrips()
    }
    
    func applicationDidBecomeActiveNotification() {
        setupLocationManager()
        refreshTrips()
    }
    
    func showLocationWarning() {
        let alertController = UIAlertController(title: "Can't Access Location Services", message: "Enable Location Services ", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            if let settingsURL = NSURL(string:UIApplicationOpenSettingsURLString) {
            UIApplication.sharedApplication().openURL(settingsURL)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
            if let settingsURL = NSURL(string:UIApplicationOpenSettingsURLString) {
                UIApplication.sharedApplication().openURL(settingsURL)
            }
        }))
        
        self.presentViewController(alertController, animated: true, completion: nil)

    }
    
    // MARK: TripManagerDelegate methods
    func didUpdateAuthorizationStatus(manager:CLLocationManager, status:CLAuthorizationStatus) {
        setupLocationManager()
    }
    
    func refreshTrips() {
        trips = tripDao.findAll()
        tableView.reloadData()
    }
    
    func didCreateNewTrip() {
        refreshTrips()
    }
}

