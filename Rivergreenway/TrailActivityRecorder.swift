//
//  TrailActivityRecorder.swift
//  Rivergreenway
//
//  Created by Scott Weidenkopf on 1/29/16.
//  Copyright © 2016 City of Fort Wayne Rivergreenways. All rights reserved.
//

import Foundation

class TrailActivityRecorder {
    
    private let AVERAGE_BMR: Double = 1577.5
    
    private var state: TrailActivityState = .CREATED
    private var exerciseType: ExerciseType
    private var BMR: Double
    
    private var path: [GMSMutablePath]
    private var segment: GMSMutablePath
    
    private var startTime: NSTimeInterval
    private var currLocation: CLLocation?
    private var lastLocation: CLLocation?
    private var distance: CLLocationDistance = 0
    private var duration: NSTimeInterval = 0
    private var calories: Double = 0
    
    init(startTime: NSTimeInterval, exerciseType: ExerciseType, BMR: Double? = nil) {
        path = [GMSMutablePath]()
        segment = GMSMutablePath()
        self.exerciseType = exerciseType
        self.startTime = startTime
        
        if BMR == nil {
            self.BMR = AVERAGE_BMR
        } else {
            self.BMR = BMR!
        }
    }
    
    
    func getActivity() -> TrailActivity {
        return TrailActivity(startTime: startTime, duration: duration, path: path, exerciseType: exerciseType, caloriesBurned: calories)
    }
    
    func getState() -> TrailActivityState {
        return state
    }
    
    func getSegment() -> GMSMutablePath {
        return segment
    }
    
    func isRecording() -> Bool {
        return state == .STARTED || state == .RESUMED
    }
    
    func update(newLocation: CLLocation) throws {
        if state != .STARTED && state != .RESUMED {
            throw RecorderError.INCORRECT_STATE
        }
        segment.addCoordinate(newLocation.coordinate)
        lastLocation = currLocation
        currLocation = newLocation
        
        // update the aggregate distance and duration and calories
        let tempDistance = lastLocation != nil ? Converter.metersToFeet(currLocation!.distanceFromLocation(lastLocation!)) : 0
        distance += tempDistance / 5280
        duration += lastLocation != nil ? currLocation!.timestamp.timeIntervalSinceDate(lastLocation!.timestamp) : 0
        calories =  (BMR / 24) * exerciseType.rawValue * (duration / 3600)
    }
    
    func getDistance() -> CLLocationDistance {
        return distance
    }
    
    func getDuration() -> NSTimeInterval {
        return duration
    }
    
    func getCalories() -> Double {
        return calories
    }
    
    func getSpeed() -> Double {
        return currLocation != nil ? currLocation!.speed : 0
    }
    
    func start() throws {
        if state != .CREATED {
            throw RecorderError.INCORRECT_TRANSITION
        }
        segment = GMSMutablePath()
        state = .STARTED
    }
    
    func pause() throws {
        if state != .STARTED && state != .RESUMED {
            throw RecorderError.INCORRECT_TRANSITION
        }
        path.append(segment)
        segment.removeAllCoordinates()
        state = .PAUSED
    }
    
    func resume() throws {
        if state != .PAUSED {
            throw RecorderError.INCORRECT_TRANSITION
        }
        segment = GMSMutablePath()
        lastLocation = nil
        currLocation = nil
        state = .RESUMED
    }
    
    func stop() throws {
        if state == .CREATED {
            throw RecorderError.INCORRECT_TRANSITION
        }
        if state == .RESUMED || state == .STARTED {
            path.append(segment)
        }
        state = .STOPPED
    }
    
    enum RecorderError: ErrorType {
        case INCORRECT_STATE
        case INCORRECT_TRANSITION
    }
}