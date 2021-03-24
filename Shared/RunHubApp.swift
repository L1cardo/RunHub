//
//  RunHubApp.swift
//  Shared
//
//  Created by Licardo on 2021/3/22.
//

import SwiftUI
import WidgetKit

@main
struct RunHubApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .active:
                print("scene is now active!")
                NotificationCenter.default.post(Notification(name: Notification.Name("active")))
                WidgetCenter.shared.reloadAllTimelines()
            case .inactive:
                print("scene is now inactive!")
                WidgetCenter.shared.reloadAllTimelines()
            case .background:
                print("scene is now in the background!")
            @unknown default:
                print("Apple must have added something new!")
            }
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        NotificationCenter.default.post(Notification(name: Notification.Name("active")))
        Tools.shared.getDeviceEnvironment()
        return true
    }
}
