//
// Copyright (C) 2016 Jared Perry, Jaron Somers, Warren Barnes, Scott Weidenkopf, and Grant Grimm
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software
// and associated documentation files (the "Software"), to deal in the Software without restriction,
// including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies
// or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
// LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
// THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//
//  UserStatisticsResponse.swift
//  Rivergreenway
//
//  Created by Jared P on 3/24/16.
//  Copyright © 2016 City of Fort Wayne Greenways and Trails Department. All rights reserved.
//

import Foundation
import JSONJoy

/**
 Represents the JSON response for AccountStatistics. The JSON is
 divided into a sub-section for the overall statistics and sub-sections
 for each exercise type. The sub-sections are represented in the
 SingleStatistic objects.
 */
struct UserStatisticsResponse : JSONJoy {
    let stats: [SingleStatistic]
    
    init(_ decoder: JSONDecoder) throws {
        guard let ra = decoder.array else {
            throw JSONError.WrongType
        }
        
        var statsArray = [SingleStatistic]()
        for item in ra {
            guard let thisStatistic = try? SingleStatistic(item) else {
                throw JSONError.WrongType
            }
            statsArray.append(thisStatistic)
        }
        self.stats = statsArray
    }
}

/**
 Statistic for a single exercise type (or overall)
 */
struct SingleStatistic : JSONJoy {
    let calories: Int
    let distance: Double
    let duration: NSTimeInterval
    let type: String
    
    init(_ decoder: JSONDecoder) throws {
        let uCalories = try decoder["total_calories"].getInt()
        let uDistance = try decoder["total_distance"].getDouble()
        let uDuration = try decoder["total_duration"].getString()
        let uType = try decoder["type"].getString()
        
        let oCalories: Int? = uCalories
        let oDistance: Double? = uDistance
        let oDuration: NSTimeInterval? = Converter.stringToTimeInterval(uDuration)
        let oType: String? = uType
        
        if oCalories == nil || oDistance == nil || oDuration == nil || oType == nil {
            throw JSONError.WrongType
        }
        
        self.calories = oCalories!
        self.distance = oDistance!
        self.duration = oDuration!
        self.type = oType!
    }
}