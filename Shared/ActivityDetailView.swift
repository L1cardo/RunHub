//
//  ActivityDetailView.swift
//  RunHub
//
//  Created by Licardo on 2021/3/23.
//

import SwiftUI

struct ActivityDetailView: View {
    var activity: Activity
    
    var body: some View {
        NavigationView {
            Text(activity.name)
        }
    }
}

//struct ActivityDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ActivityDetailView()
//    }
//}
