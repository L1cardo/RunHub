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
    @State private var showProgressView = false
    
    var body: some View {
        NavigationView {
            VStack {
                if showProgressView {
                    ProgressView()
                } else {
                    ActivityGridView(distances: svgDistances)
                        .frame(height: 150)
                        .padding()
                }
                Spacer()
                
//                List {
//                    ForEach(self.activities.reversed(), id: \.run_id) { activity in
//                        NavigationLink(destination: ActivityDetailView(activity: activity)) {
//                            ActivityListCell(activity: activity)
//                        }
//                    }
//                }
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
    
    
    

    
    
//    private func daysOfThisYear() -> Int {
//        today.isLeapYear ? 366 : 365
//    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
