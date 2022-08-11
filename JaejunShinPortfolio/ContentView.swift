//
//  ContentView.swift
//  JaejunShinPortfolio
//
//  Created by Jaejun Shin on 10/8/2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("House")
                }
            
            projectsView(showClosedProjects: false)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Open")
                }
            
            projectsView(showClosedProjects: true)
                .tabItem {
                    Image(systemName: "checkmark")
                    Text("Closed")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var dataController = DataController()
    
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
