//
//  ActivityListCell.swift
//  RunHub
//
//  Created by Licardo on 2021/3/23.
//

import SwiftUI
import SwiftDate

struct ActivityListCell: View {
    var activity: Activity
    
    var body: some View {
        HStack {
            //Text(activity.name)
            
            Text(activity.distance.toKMString())
            
            Text(getPace())
            
            Text("\(Int(activity.average_heartrate))")
            
            Spacer()
            
            Text(activity.start_date_local)
        }
    }
    
    private func getPace() -> String {
        let min = activity.moving_time.toDate()!.minute
        let sec = activity.moving_time.toDate()!.second
        let totalMin = Double(min) + Double(sec) / 60
        let paceMin = Double(totalMin) / (activity.distance / 1000)
        let pace = (paceMin * 60).toIntervalString()
        return "\(pace)"
    }
    
}

//struct ActivityListCell_Previews: PreviewProvider {
//    static var previews: some View {
//        ActivityListCell(activity: Activity(from: <#JSON#>))
//    }
//}
