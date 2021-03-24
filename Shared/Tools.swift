//
//  Tools.swift
//  RunHub
//
//  Created by Licardo on 2021/3/23.
//

import Alamofire
import SwiftyJSON
import SwiftDate
import Defaults
import SwiftSoup
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
    func getActivities(callback: @escaping (_ activities: [Activity]) -> ()) {
        var activities: [Activity] = []
        let url = Defaults[.activitiesURL]
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value).reversed()
                
                for (_, activity) in json {
                    // 只添加今年的数据
                    if Activity(from: activity).start_date_local.toDate()!.compare(.isSameYear(DateInRegion(region: .current))) {
                        activities.append(Activity(from: activity))
                    } else {
                        break
                    }
                }
                
                callback(activities.reversed())
            case .failure(let error):
                //Defaults[.distances].removeAll()
                print("HTTP Capture: \(error.localizedDescription)")
            }
        }
    }
    
    func getDistance() {
        var distances: [Double] = []
        
        getActivities { activities in
            for i in 0..<DateInRegion(region: .current).dayOfYear {//1月1号至今的天数
                distances.append(0.0)
                
                let date = DateInRegion(year: DateInRegion(region: .current).year, month: 1, day: 1) + i.days
                for activity in activities {
                    if activity.start_date_local.toDate()!.compare(.isSameDay(date)) {
                        distances[i] += activity.distance
                    }
                }
            }
            
            // 补齐1.1号之前的天数
            if DateInRegion(year: DateInRegion(region: .current).year, month: 1, day: 1).weekday == 1 {
                // 星期天(n=1)--补6次
                for _ in 0..<6 {
                    distances.insert(0.0, at: 0)
                }
            } else {
                // 其他补n-2次
                for _ in 0..<DateInRegion(year: DateInRegion(region: .current).year, month: 1, day: 1).weekday - 2 {
                    distances.insert(0.0, at: 0)
                }
            }
            
            Defaults[.distances] = distances
        }
    }
    
    func getDistanceFromSVG() {
        var svgDistances: [Double] = []
        guard !Defaults[.svgURL].isEmpty else { return }
        let url = URL(string: Defaults[.svgURL])!
        
        do {
            let html = try String(contentsOf: url, encoding: .utf8)
            let document = try SwiftSoup.parse(html)
            Defaults[.title] = try document.select("text").first()?.text() ?? ""
            var svgDistancesArray = try document.select("rect").array()
            
            if Defaults[.svgIsAscending] { //svg文件的年份是升序
                svgDistancesArray = svgDistancesArray.reversed()
                for svgDistance in svgDistancesArray {
                    let text = try svgDistance.text()
                    
                    if text.prefix(4) != DateInRegion(region: .current).toFormat("yyyy") {
                        // 不是今年的数据时不要
                        break
                    } else {
                        if !(text.toDate()?.compare(.isInTheFuture) ?? false) {
                            if text.components(separatedBy: " ").count > 1 {
                                let distance = Double(text.components(separatedBy: " ")[1])!
                                svgDistances.insert(distance, at: 0)
                            } else {
                                svgDistances.insert(0.0, at: 0)
                            }
                        }
                        
                    }
                }
                svgDistancesArray = svgDistancesArray.reversed()
                
                // 补齐1.1号之前的天数
                if DateInRegion(year: DateInRegion(region: .current).year, month: 1, day: 1).weekday == 1 {
                    // 星期天(n=1)--补6次
                    for _ in 0..<6 {
                        svgDistances.insert(0.0, at: 0)
                    }
                } else {
                    // 其他补n-2次
                    for _ in 0..<DateInRegion(year: DateInRegion(region: .current).year, month: 1, day: 1).weekday - 2 {
                        svgDistances.insert(0.0, at: 0)
                    }
                }
            } else { //svg文件的年份是降序
                for svgDistance in svgDistancesArray {
                    let text = try svgDistance.text()
                    
                    if svgDistances.count > 6 && text.prefix(4) != DateInRegion(region: .current).toFormat("yyyy") {
                        // 数据>6且不是今年的数据时不要
                        // >6是为了补齐1.1号之前上一年的数据, 如果1.1号时星期天，那么上一年的补齐数据为数6
                        break
                    } else {
                        if !(text.toDate()?.compare(.isInTheFuture) ?? false) {
                            if text.components(separatedBy: " ").count > 1 {
                                let distance = Double(text.components(separatedBy: " ")[1])!
                                svgDistances.append(distance)
                            } else {
                                svgDistances.append(0.0)
                            }
                        }
                        
                    }
                }
                
                svgDistances.remove(at: 0) // 去除一个无效元素
            }

            Defaults[.svgDistances] = svgDistances
        } catch {
            print(error.localizedDescription)
        }
    }
}
