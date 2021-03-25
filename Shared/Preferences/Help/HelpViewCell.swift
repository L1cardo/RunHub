//
//  HelpViewCell.swift
//  RunHub
//
//  Created by Licardo on 2021/3/25.
//

import SwiftUI

struct HelpViewCell: View {
    var q: String
    var a: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Q:")
                Text(q)
                
            }
            HStack(alignment: .top) {
                Text("A:")
                Text(a)
            }
            .font(.callout)
        }
    }
}

struct HelpViewCell_Previews: PreviewProvider {
    static var previews: some View {
        HelpViewCell(q: "", a: "")
    }
}
