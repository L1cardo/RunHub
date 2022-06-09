//
//  ContentView.swift
//  Shared
//
//  Created by Licardo on 2021/3/22.
//

import SwiftUI
import Defaults

struct ContentView: View {
    
    @Default(.distances) var distances
    @Default(.svgDistances) var svgDistances
    @State private var showPreferencesSheet = false
    
    var body: some View {
        NavigationView {
            List {
                ActivityGridView(distances: svgDistances)
                    .padding(.vertical)
            }
            .navigationBarTitle("RunHub")
            .navigationBarItems(
                trailing: Button {
                    showPreferencesSheet.toggle()
                } label: {
                    Image(systemName: "ellipsis")
                }
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $showPreferencesSheet) {
            PreferencesView()
        }
        .onAppear {
            //Tools.shared.getDistance()
            Tools.shared.getDistanceFromSVG()
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("active"))) { _ in
            //Tools.shared.getDistance()
            Tools.shared.getDistanceFromSVG()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
