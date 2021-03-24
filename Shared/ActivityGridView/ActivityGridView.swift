//
//  ActivityGridView.swift
//  RunHub
//
//  Created by Licardo on 2021/3/23.
//

import SwiftUI
import SwiftDate
import Defaults

struct ActivityGridView: View {
    var distances: [Double]
    @Default(.title) var title
    
    let weekdays = ["Mon", " ", "Wed", " ", "Fri", " ", "Sun"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if distances.count == 0 {
                Text("Please add a URL in prefrences page")
                    .foregroundColor(.secondary)
            } else {
                HStack {
                    Text(title)
                    Text(DateInRegion(region: .current).toFormat("yyyy"))
                    Spacer()
                    Text(totalDistance())
                }
                .foregroundColor(Color("SecondaryColor"))
                .font(.caption2)
                
                LazyHGrid(rows: [
                    GridItem(.fixed(7)),
                    GridItem(.fixed(7)),
                    GridItem(.fixed(7)),
                    GridItem(.fixed(7)),
                    GridItem(.fixed(7)),
                    GridItem(.fixed(7)),
                    GridItem(.fixed(7)),
                ], spacing: 3) {
                    ForEach(distances.indices, id: \.self) { index in
                        //ActivityGrid(distance: distances[index])
                        SVGActivityGrid(distance: distances[index])
                    }
                }
            }
        }
    }
    
    private func totalDistance() -> String {
        var totalDistance = 0.0
        distances.forEach { (distance) in
            totalDistance += distance
        }
        return "\(totalDistance.toKMString()) KM"
    }
}

struct ActivityGridView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityGridView(distances: [])
    }
}
