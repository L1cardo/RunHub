//
//  ActivityGrid.swift
//  RunHub
//
//  Created by Licardo on 2021/3/22.
//

import SwiftUI
import Defaults

struct ActivityGrid: View {
    var distance: Double
    
    @Default(.greenMax) var greenMax
    @Default(.blueMax) var blueMax
    @Default(.orangeMax) var orangeMax
    
    var body: some View {
        RoundedRectangle(cornerRadius: 2)
            .frame(width: 12, height: 12)
            .foregroundColor(setCellColor(distance))
            .overlay(
                RoundedRectangle(cornerRadius: 2)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
    }
    
    private func setCellColor(_ distance: Double) -> Color {
        switch distance {
        case _ where distance > 0 && distance < (Double(greenMax) ?? 3) * 1000:
            return .green
        case _ where distance > (Double(greenMax) ?? 3) * 1000 && distance < (Double(blueMax) ?? 5) * 1000:
            return .blue
        case _ where distance > (Double(blueMax) ?? 5) * 1000 && distance < (Double(orangeMax) ?? 10) * 1000:
            return .orange
        case _ where distance > (Double(orangeMax) ?? 10) * 1000 && distance < Double.infinity:
            return .red
        default:
            return Color("GreyGridColor")
        }
    }
}

struct ActivityCell_Previews: PreviewProvider {
    static var previews: some View {
        ActivityGrid(distance: 0)
    }
}
