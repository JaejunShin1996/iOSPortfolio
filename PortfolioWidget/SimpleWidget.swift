//
//  SimpleWidget.swift
//  PortfolioWidgetExtension
//
//  Created by Jaejun Shin on 17/9/2022.
//

import SwiftUI
import WidgetKit

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

struct SimplePortfolioWidget: Widget {
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
