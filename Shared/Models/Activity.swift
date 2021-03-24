//
//  Activity.swift
//  RunHub
//
//  Created by Licardo on 2021/3/22.
//

import Foundation
import SwiftyJSON

struct Activity {
    var run_id: Int = 0
    var name: String = ""
    var distance: Double = 0.0
    var moving_time: String = ""
    var type: String = ""
    var start_date: String = ""
    var start_date_local: String = ""
    var location_country: String = ""
    var summary_polyline: String = ""
    var average_heartrate: Int = 0
    var average_speed: Double = 0.0
    var streak: Int = 0

    init(from json: JSON) {
        run_id = json["run_id"].intValue
        name = json["name"].stringValue
        distance = json["distance"].doubleValue
        moving_time = json["moving_time"].stringValue
        type = json["type"].stringValue
        start_date = json["start_date"].stringValue
        start_date_local = json["start_date_local"].stringValue
        location_country = json["location_country"].stringValue
        summary_polyline = json["summary_polyline"].stringValue
        average_heartrate = json["average_heartrate"].intValue
        average_speed = json["average_speed"].doubleValue
        streak = json["streak"].intValue
    }
}
