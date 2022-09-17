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

    func linkToItemView(to item: Item) -> some View {
        NavigationLink(destination: EditItemView(item: item)) {
            HStack(spacing: 20) {
                Circle()
                    .stroke(Color(item.project?.projectColor ?? "Light Blue"), lineWidth: 3)
                    .frame(width: 44, height: 44)

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
            .padding()
            .background(Color.secondarySystemGroupedBackground)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.2), radius: 5)
        }
    }
}
