//
//  ColorRangeView.swift
//  RunHub
//
//  Created by Licardo on 2021/3/23.
//

import SwiftUI

struct ColorRangeView: View {
    var color: Color
    @Binding var min: String
    @Binding var max: String
    
    var body: some View {
        HStack {
            if color == .green || color == Color("GreenLevel1") {
                Text("0         ")
                    .multilineTextAlignment(.leading)
                    .frame(width: 50)
            } else {
                TextField("", text: $min)
                    .multilineTextAlignment(.leading)
                    .frame(width: 50)
                    .keyboardType(.decimalPad)
            }
            Spacer()
            Text(color == .green || color == Color("GreenLevel1") ? "<" : "≤")
                .frame(width: 50)
            Spacer()
            RoundedRectangle(cornerRadius: 2)
                .frame(width: 20, height: 20)
                .foregroundColor(color)
                .overlay(
                    RoundedRectangle(cornerRadius: 2)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
            Spacer()
            Text("<")
                .frame(width: 50)
            Spacer()
            
            if color == .red || color == Color("GreenLevel4") {
                Text("        ∞")
                    .multilineTextAlignment(.trailing)
                    .frame(width: 50)
            } else {
                TextField("", text: $max)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 50)
                    .keyboardType(.decimalPad)
            }
        }
    }
}

struct ColorRangeView_Previews: PreviewProvider {
    static var previews: some View {
        ColorRangeView(color: .blue, min: .constant("3"), max: .constant("5"))
    }
}
