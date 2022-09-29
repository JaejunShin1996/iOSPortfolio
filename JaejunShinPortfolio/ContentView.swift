//
//  ContentView.swift
//  JaejunShinPortfolio
//
//  Created by Jaejun Shin on 10/8/2022.
//

import CoreSpotlight
import SwiftUI

struct ContentView: View {
    @SceneStorage("selectedView") var selectedView: String?
    @EnvironmentObject var dataController: DataController

    private let newProjectActivity = "com.jaejunshin.JaejunShinPortfolio.newProject"

    @State private var showingUnlockView = false

    var body: some View {
        TabView(selection: $selectedView) {
            HomeView(dataController: dataController)
                .tag(HomeView.tag)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }

            ProjectsView(dataController: dataController, showClosedProjects: false)
                .tag(ProjectsView.openTag)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Open")
                }

            ProjectsView(dataController: dataController, showClosedProjects: true)
                .tag(ProjectsView.closedTag)
                .tabItem {
                    Image(systemName: "checkmark")
                    Text("Closed")
                }

            AwardsView()
                .tag(AwardsView.tag)
                .tabItem {
                    Image(systemName: "rosette")
                    Text("Awards")
                }

            SharedProjectView()
                .tag(SharedProjectView.tag)
                .tabItem {
                    Image(systemName: "person.3")
                    Text("Community")
                }
        }
        .onContinueUserActivity(CSSearchableItemActionType, perform: moveToHome)
        .onContinueUserActivity(newProjectActivity, perform: createProjectFromShortcut)
        .userActivity(newProjectActivity, { activity in
            activity.title = "New Project"

            #if os(iOS) || os(watchOS)
            activity.isEligibleForPrediction = true
            #endif
        })
        .sheet(isPresented: $showingUnlockView, content: { UnlockView() })
        .onOpenURL(perform: openURL)
    }

    func moveToHome(_ input: Any) {
        selectedView = HomeView.tag
    }

    func openURL(_ url: URL) {
        selectedView = ProjectsView.openTag
        let newProject = dataController.addProject()

        if newProject == false {
            showingUnlockView.toggle()
        }
    }

    func createProjectFromShortcut(_ userActitivy: NSUserActivity) {
        selectedView = ProjectsView.openTag
        dataController.addProject()
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
