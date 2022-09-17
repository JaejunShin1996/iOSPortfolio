//
//  PortfolioWidget.swift
//  PortfolioWidget
//
//  Created by Jaejun Shin on 16/9/2022.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: TimelineProvider {
    typealias Entry = SimpleEntry

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), items: loadItems())
    }

    func getSnapshot(
        in context: Context,
        completion: @escaping (SimpleEntry
        ) -> Void) {
        let entry = SimpleEntry(date: Date(), items: loadItems())
        completion(entry)
    }

    func getTimeline(
        in context: Context,
        completion: @escaping (Timeline<Entry>
        ) -> Void) {
        let entry: SimpleEntry = SimpleEntry(date: Date(), items: loadItems())
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }

    func loadItems() -> [Item] {
        let dataController = DataController()
        let itemRequest = dataController.fetchRequestForTopItems(count: 5)
        return dataController.results(for: itemRequest)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let items: [Item]
}

struct PortfolioWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Up Next…")
                .font(.title)

            if let item = entry.items.first {
                Text(item.itemTitle)
                    .italic()
            } else {
                Text("Nothing!")
            }
        }
    }
}

@main
struct PortfolioWidget: Widget {
    let kind: String = "PortfolioWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            PortfolioWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Up Next…")
        .description("Your No.1 top-priority item.")
        .supportedFamilies([.systemSmall])
    }
}

struct PortfolioWidget_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioWidgetEntryView(entry: SimpleEntry(
            date: Date(),
            items: [Item.example])
        )
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
