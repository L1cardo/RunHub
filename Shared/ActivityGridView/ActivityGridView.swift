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
    @Default(.year) var year
    @Default(.totalDistance) var totalDistance
    @Default(.error) var error
    
    let weekdays = ["Mon", " ", "Wed", " ", "Fri", " ", "Sun"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if distances.count == 0 {
                HStack {
                    Text("Please add a URL in preferences page")
                        .foregroundColor(.secondary)
                    Spacer()
                }
            } else if error != "" {
                HStack {
                    Text(error)
                        .foregroundColor(.red)
                    Spacer()
                }
            } else {
                HStack {
                    Text(title)
                    Text(DateInRegion(region: .current).toFormat("yyyy"))
                    Spacer()
                    Text(totalDistance)
                }
                .foregroundColor(Color("SecondaryColor"))
                //.foregroundColor(Color.init(hex: "#C6F820"))
                .textCase(.uppercase)
                .lineLimit(1)
                .font(.custom("Futura Extra Bold Condensed Oblique", size: 11))
                
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
        .font(.caption2)
    }
    
//    private func totalDistance() -> String {
//        var totalDistance = 0.0
//        distances.forEach { (distance) in
//            totalDistance += distance
//        }
//        return "\(totalDistance.toKMString()) KM"
//    }
}

struct ActivityGridView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityGridView(distances: [])
    }
}
