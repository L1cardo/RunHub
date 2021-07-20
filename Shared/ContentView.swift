//
//  ContentView.swift
//  Shared
//
//  Created by Licardo on 2021/3/22.
//

import SwiftUI
import Defaults

struct ContentView: View {
    
    @Default(.distancesFromSVG) var distancesFromSVG
    @State private var showPreferencesSheet = false
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            List {
                ActivityGridView(distances: distancesFromSVG)
                    .padding(.vertical)
            }
            .navigationBarTitle("RunHub")
            .navigationBarItems(
                leading: Button {
                    Tools.shared.getDistanceFromSVG()
                } label: {
                    if isLoading {
                        ProgressView()
                    } else {
                        Image(systemName: "arrow.counterclockwise.circle")
                    }
                }.disabled(isLoading),
                trailing: Button {
                    showPreferencesSheet.toggle()
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $showPreferencesSheet) {
            PreferencesView()
        }
        .onAppear {
            Tools.shared.getDistanceFromSVG()
            Tools.shared.getDistanceFromHealthKit()
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("active"))) { _ in
            Tools.shared.getDistanceFromSVG()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
