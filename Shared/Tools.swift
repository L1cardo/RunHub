//
//  Tools.swift
//  RunHub
//
//  Created by Licardo on 2021/3/23.
//

import SwiftDate
import Defaults
import SwiftSoup
import HealthKitReporter
#if os(iOS)
import UIKit
#else
import AppKit
#endif

class Tools {
    static let shared = Tools()
}

// MARK: - 获取运行环境
extension Tools {
    func getDeviceEnvironment() {
        getDeviceInfo()
        getAppInfo()
    }
    
    // 设备信息
    func getDeviceInfo() {
        #if os(iOS)
        Defaults[.systemVersion] = UIDevice.current.systemVersion // 系统版本
        Defaults[.systemName] = UIDevice.current.systemName // 系统名称
        
        #else
        let os = ProcessInfo.processInfo.operatingSystemVersion
        Defaults[.systemVersion] = "\(os.majorVersion).\(os.minorVersion).\(os.patchVersion)"
        Defaults[.systemName] = "macOS"
        
        #endif
        
        let model = modelIdentifier()
        
        if let devicesJSONFile = Bundle.main.url(forResource: "devices", withExtension: "json"), let devicesData = try? Data(contentsOf: devicesJSONFile) {
            let decoder = JSONDecoder()
            let devices = try? decoder.decode(Devices.self, from: devicesData)
            if let deviceName = devices?.content[model] {
                Defaults[.deviceName] = deviceName
            }
        }
    }
    
    // app 信息
    func getAppInfo() {
        Defaults[.versionNum] = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        Defaults[.buildNum] = Bundle.main.infoDictionary?["CFBundleVersion"] as! String
    }
    
    func modelIdentifier() -> String {
        #if os(iOS)
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let modelIdentifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return modelIdentifier
        
        #else
        var modelIdentifier: String?
        let service = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPlatformExpertDevice"))
        if let modelData = IORegistryEntryCreateCFProperty(service, "model" as CFString, kCFAllocatorDefault, 0).takeRetainedValue() as? Data {
            modelIdentifier = String(data: modelData, encoding: .utf8)?.trimmingCharacters(in: .controlCharacters)
        }
        IOObjectRelease(service)
        return modelIdentifier ?? "Mac"
        
        #endif
    }
}

// MARK: - activity 相关
extension Tools {
    func getDistanceFromSVG() {
        var distancesFromSVG: [Double] = []
        let urlString = Defaults[.urlType] == 0 ? "https://raw.githubusercontent.com/\(Defaults[.githubUsername])/running_page/master/assets/github.svg" : Defaults[.svgURL]
        
        guard let url = URL(string: urlString) else {
            Defaults[.error] = NSLocalizedString("Please check your SVG file URL", comment: "Please check your SVG file URL")
            return
        }
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            do {
                let html = String(data: data, encoding: .utf8)!
                let document = try SwiftSoup.parse(html)
                Defaults[.title] = try document.select("text")[0].text()
                Defaults[.year] = try document.select("text")[10].text()
                Defaults[.totalDistance] = try document.select("text")[11].text()
                
                let svgDistancesArray = try document.select("rect").array()
                for svgDistance in svgDistancesArray {
                    let text = try svgDistance.text()
                    
                    if distancesFromSVG.count > 6 && text.prefix(4) != DateInRegion(region: .current).toFormat("yyyy") {
                        // 数据>6且不是今年的数据时不要
                        // >6是为了补齐1.1号之前上一年的数据, 如果1.1号时星期天，那么上一年的补齐数据为数6
                        break
                    } else {
                        if !text.isEmpty {
                            if !(text.toDate()?.compare(.isInTheFuture) ?? false) {
                                if text.components(separatedBy: " ").count > 1 {
                                    let distance = Double(text.components(separatedBy: " ")[1])!
                                    distancesFromSVG.append(distance)
                                } else {
                                    distancesFromSVG.append(0.0)
                                }
                            }
                        }
                    }
                }
                
                if distancesFromSVG.count > 140 {
                    let remainder = distancesFromSVG.count % 7
                    
                    if remainder == 0 {
                        Defaults[.distancesFromSVG] = distancesFromSVG.reversed()[0..<140].reversed()
                    } else {
                        var last: [Double] = []
                        for _ in 0..<remainder {
                            last.append(distancesFromSVG.last!)
                            distancesFromSVG = distancesFromSVG.dropLast()
                        }
                        Defaults[.distancesFromSVG] = distancesFromSVG.reversed()[0..<133].reversed() + last.reversed()
                    }
                } else {
                    Defaults[.distancesFromSVG] = distancesFromSVG
                }
                
                Defaults[.error] = ""
            } catch {
                print(error.localizedDescription)
                Defaults[.error] = error.localizedDescription
            }
        }
        task.resume()
    }
    
    func getDistanceFromHealthKit() {
        var distances: [[Double]] = []
        var distancesFromHealthKit: [Double] = []
        var totalDistance = 0.0
        do {
            let reporter = try HealthKitReporter()
            let types: [WorkoutType] = [.workoutType]
            
            reporter.manager.requestAuthorization(toRead: types, toWrite: []) { (success, error) in
                if success && error == nil {
                    do {
                        let query = try reporter.reader.workoutQuery { (workouts, error) in
                            if error == nil {
                                for workout in workouts {
                                    if DateInRegion(seconds: workout.startTimestamp, region: .current).compare(.isThisYear) {
                                        if workout.harmonized.totalDistance != nil  {
                                            let time = workout.startTimestamp
                                            let distance = workout.harmonized.totalDistance! / 1000
                                            distances.append([time, distance])
                                            totalDistance += (workout.harmonized.totalDistance! / 1000)
                                        }
                                    } else {
                                        break
                                    }
                                }
                            } else {
                                print(error!.localizedDescription)
                            }
                            print(distances.count)
                            
                            for i in 0..<distances.count where (i + 1) < distances.count {
                                if DateInRegion(seconds: distances[i][0], region: .current).day == DateInRegion(seconds: distances[i + 1][0], region: .current).day {
                                    distances[i][1] = distances[i][1] + distances[i + 1][1]
                                    distances.remove(at: i + 1)
                                }
                            }
                            
                            print(distances)
                            Defaults[.totalDistance] = String(format: "%.2f KM", totalDistance)
                        }
                        reporter.manager.executeQuery(query)
                    } catch {
                        print(error.localizedDescription)
                    }
                } else {
                    print(error!.localizedDescription)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
