//
//  HomeView.swift
//  JaejunShinPortfolioMac
//
//  Created by Jaejun Shin on 30/9/2022.
//

import SwiftUI

struct HomeView: View {
    static var tag: String? = "Home"
    @StateObject var viewModel: ViewModel

    init(dataController: DataController) {
        let viewModel = ViewModel(dataController: dataController)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            List {
                ItemListView(title: "Up next", items: $viewModel.upNext)
                ItemListView(title: "More to Explore", items: $viewModel.moreToExplore)
            }
            .listStyle(.sidebar)
            .navigationTitle("Home")
            .toolbar {
                Button("Add Data", action: viewModel.addSampleData)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(dataController: .preview)
    }
}
