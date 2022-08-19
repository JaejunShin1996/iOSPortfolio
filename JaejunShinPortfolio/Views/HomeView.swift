//
//  HomeView.swift
//  JaejunShinPortfolio
//
//  Created by Jaejun Shin on 10/8/2022.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var dataController: DataController
    
    static let tag: String? = "Home"
    
    var body: some View {
        NavigationView {
            VStack {
                Button("Add Data") {
                    dataController.deleteAll()
                    try? dataController.createSampleData()
                }
            }
            .navigationTitle("Home")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
