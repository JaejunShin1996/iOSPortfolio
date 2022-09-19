//
//  PortfolioWidget.swift
//  PortfolioWidget
//
//  Created by Jaejun Shin on 16/9/2022.
//

import WidgetKit
import SwiftUI

@main
struct PortfolioWidgets: WidgetBundle {
    var body: some Widget {
        SimplePortfolioWidget()
        ComplexPortfolioWidget()
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
