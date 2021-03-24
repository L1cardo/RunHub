//
//  iOSWidget.swift
//  iOSWidget
//
//  Created by Licardo on 2021/3/23.
//

import WidgetKit
import SwiftUI
import Intents
import Defaults

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent(), distances: [])
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration, distances: [])
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        let currentDate = Date()
        let entryDate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
        
        //Tools.shared.getDistance()
        Tools.shared.getDistanceFromSVG()
        
        let entry = SimpleEntry(date: entryDate, configuration: configuration, distances: Defaults[.svgDistances])
        entries.append(entry)
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let distances: [Double]
}

struct iOSWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        ZStack {
            Color("WidgetBackground")
            ActivityGridView(distances: entry.distances)
                .padding()
        }
    }
}

@main
struct iOSWidget: Widget {
    let kind: String = "RunHubWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            iOSWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("RunHub Widget")
        .description("Show your running activities.")
        .supportedFamilies([.systemMedium])
    }
}

struct iOSWidget_Previews: PreviewProvider {
    static var previews: some View {
        iOSWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), distances: []))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
