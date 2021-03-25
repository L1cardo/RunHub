//
//  HelpView.swift
//  RunHub
//
//  Created by Licardo on 2021/3/25.
//

import SwiftUI

struct HelpView: View {
    let qas = [
        QA(q: "What is a Raw URL of 'github.svg'", a: "svgURLTip"),
        
    ]
    
    var body: some View {
        List {
            ForEach(qas, id: \.q) { qa in
                HelpViewCell(q: qa.q, a: qa.a)
            }
        }
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}

struct QA {
    var q: String
    var a: String
}
