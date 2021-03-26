//
//  SVGActivityGrid.swift
//  RunHub
//
//  Created by Licardo on 2021/3/24.
//

import SwiftUI
import Defaults

struct SVGActivityGrid: View {
    var distance: Double
    
    @Default(.greenMax) var greenMax
    @Default(.blueMax) var blueMax
    @Default(.orangeMax) var orangeMax
    @Default(.colorStyle) var colorStyle
    
    var body: some View {
        RoundedRectangle(cornerRadius: 2)
            .frame(width: 12.5, height: 12.5)
            .foregroundColor(setCellColor(distance))
            .overlay(
                RoundedRectangle(cornerRadius: 2)
                    .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
            )
    }

    private func setCellColor(_ distance: Double) -> Color {
        switch distance {
        case _ where distance > 0 && distance < (Double(greenMax) ?? 3):
            return colorStyle == 0 ? .green : Color("GreenLevel1")
        case _ where distance >= (Double(greenMax) ?? 3) && distance < (Double(blueMax) ?? 5):
            return colorStyle == 0 ? .blue : Color("GreenLevel2")
        case _ where distance >= (Double(blueMax) ?? 5) && distance < (Double(orangeMax) ?? 10):
            return colorStyle == 0 ? .orange : Color("GreenLevel3")
        case _ where distance >= (Double(orangeMax) ?? 10) && distance < Double.infinity:
            return colorStyle == 0 ? .red : Color("GreenLevel4")
        default:
            return Color.gray.opacity(0.2)
        }
    }
}

struct SVGActivityGrid_Previews: PreviewProvider {
    static var previews: some View {
        SVGActivityGrid(distance: 3.0)
    }
}
