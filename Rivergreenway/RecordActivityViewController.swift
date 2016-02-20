//
//  TrailActivityViewController.swift
//  Rivergreenway
//
//  Created by Scott Weidenkopf on 1/23/16.
//  Copyright © 2016 City of Fort Wayne Rivergreenways. All rights reserved.
//

import UIKit

class RecordActivityViewController: DraweredViewController, CLLocationManagerDelegate, StartPauseDelegate, ResumeFinishDelegate {

    // MARK : - Properties
    
    @IBOutlet weak var singleButtonContainerView: UIView!
    @IBOutlet weak var doubleButtonContainerView: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    
    private let recorder = TrailActivityRecorder()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        mapView.myLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        mapView.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.New, context: nil)
        
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        let myLocation: CLLocation = change![NSKeyValueChangeNewKey] as! CLLocation
        
        mapView.camera = GMSCameraPosition.cameraWithTarget(myLocation.coordinate, zoom: 17)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier! == ViewIdentifier.START_PAUSE_SEGUE.rawValue {
            let startPauseController = segue.destinationViewController as! StartPauseViewController
            startPauseController.setDelegate(self)
        } else if segue.identifier! == ViewIdentifier.RESUME_FINISH_SEGUE.rawValue {
            let resumeFinishController = segue.destinationViewController as! ResumeFinishViewController
            resumeFinishController.setDelegate(self)
        }
    }
    
    func swapContainerViews() {
        if recorder.getState() == TrailActivityState.PAUSED {
            singleButtonContainerView.alpha = 0
            doubleButtonContainerView.alpha = 1
        } else if recorder.getState() == TrailActivityState.RESUMED {
            singleButtonContainerView.alpha = 1
            doubleButtonContainerView.alpha = 0
        }
    }
    
    func start() {
        recorder.setState(TrailActivityState.STARTED)
    }
    
    func pause() {
        recorder.setState(TrailActivityState.PAUSED)
        swapContainerViews()
    }
    
    func resume() {
        recorder.setState(TrailActivityState.RESUMED)
        swapContainerViews()
    }
    
    func finish() {
        recorder.setState(TrailActivityState.STOPPED)
    }
}