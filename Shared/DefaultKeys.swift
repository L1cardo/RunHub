//
//  DefaultKeys.swift
//  RunHub
//
//  Created by Licardo on 2021/3/22.
//

import Defaults
import Foundation

let extensionDefaults = UserDefaults(suiteName: "group.com.licardo.RunHub")!

extension Defaults.Keys {
    // 运行环境
    static let deviceName = Key<String>("deviceName", default: "Unknown")
    static let systemName = Key<String>("systemName", default: "Unknown")
    static let systemVersion = Key<String>("systemVersion", default: "Unknown")
    static let versionNum = Key<String>("versionNum", default: "Unknown")
    static let buildNum = Key<String>("buildNum", default: "Unknown")
    
    static let activitiesURL = Key<String>("activitiesURL", default: "", suite: extensionDefaults)
    static let svgURL = Key<String>("svgURL", default: "", suite: extensionDefaults)
    static let githubUsername = Key<String>("githubUsername", default: "", suite: extensionDefaults)
    static let distancesFromHealthKit = Key<[Double]>("distancesFromHealthKit", default: [], suite: extensionDefaults)
    static let distancesFromSVG = Key<[Double]>("distancesFromSVG", default: [], suite: extensionDefaults)
    static let colorStyle = Key<Int>("colorStyle", default: 0, suite: extensionDefaults)
    static let urlType = Key<Int>("urlType", default: 0, suite: extensionDefaults)
    static let title = Key<String>("title", default: "", suite: extensionDefaults)
    static let year = Key<String>("year", default: "", suite: extensionDefaults)
    static let totalDistance = Key<String>("totalDistance", default: "", suite: extensionDefaults)
    static let error = Key<String>("error", default: "", suite: extensionDefaults)
    
    static let greenMax = Key<String>("greenMax", default: "3", suite: extensionDefaults)
    static let blueMax = Key<String>("blueMax", default: "5", suite: extensionDefaults)
    static let orangeMax = Key<String>("orangeMax", default: "15", suite: extensionDefaults)
}
