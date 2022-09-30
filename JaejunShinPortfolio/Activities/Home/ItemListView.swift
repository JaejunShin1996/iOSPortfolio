//
//  ItemListView.swift
//  JaejunShinPortfolio
//
//  Created by Jaejun Shin on 25/8/2022.
//

import SwiftUI

struct ItemListView: View {
    var title: LocalizedStringKey
    @Binding var items: ArraySlice<Item>

    var body: some View {
        if items.isEmpty {
            EmptyView()
        } else {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.top)

            ForEach(items) { item in
                linkToItemView(to: item)
            }
        }
    }

    #if os(macOS)
    let circleSize = 20.0
    let circleStrokeWidth = 2.0
    let horizontalSpacing = 10.0
    #else
    let circleSize = 44.0
    let circleStrokeWidth = 3.0
    let horizontalSpacing = 20.0
    #endif

    func linkToItemView(to item: Item) -> some View {
        NavigationLink(destination: EditItemView(item: item)) {
            HStack(spacing: horizontalSpacing) {
                Circle()
                    .strokeBorder(Color(item.project?.projectColor ?? "Light Blue"), lineWidth: circleStrokeWidth)
                    .frame(width: circleSize, height: circleSize)

                VStack(alignment: .leading) {
                    Text(item.itemTitle)
                        .font(.title2)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    if item.itemDetail.isEmpty == false {
                        Text(item.itemDetail)
                            .foregroundColor(.secondary)
                    }
                }
            }
            #if os(iOS)
            .padding()
            .background(Color.secondarySystemGroupedBackground)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.2), radius: 5)
            #endif
        }
    }
}
