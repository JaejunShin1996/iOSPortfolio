//
//  ProjectsView.swift
//  JaejunShinPortfolio
//
//  Created by Jaejun Shin on 10/8/2022.
//

import SwiftUI

struct ProjectsView: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext
    
    static let openTag: String? = "Open"
    static let closedTag: String? = "Closed"
    
    let showClosedProjects: Bool
    
    let projects: FetchRequest<Project>
    
    init(showClosedProjects: Bool) {
        self.showClosedProjects = showClosedProjects
        
        projects = FetchRequest<Project>(entity: Project.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Project.creationDate, ascending: false)], predicate: NSPredicate(format: "closed = %d", showClosedProjects))
    }
    
    @State private var showingSortOrder = false
    @State private var sortOrder = Item.SortOrders.optimised
    
    var projectListView: some View {
        List {
            ForEach(projects.wrappedValue) { project in
                Section(header: ProjectHeaderView(project: project)) {
                    ForEach(project.projectItems(using: sortOrder)) { item in
                        ItemRowView(project: project, item: item)
                    }
                    .onDelete { offsets in
                        onDelete(offsets, from: project)
                    }
                    
                    if showClosedProjects == false {
                        Button {
                            addItem(to: project)
                        } label: {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
    
    var addProjectToolBarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            if showClosedProjects == false {
                Button {
                    addProject()
                } label: {
                    if UIAccessibility.isVoiceOverRunning {
                        Text("Add Project")
                    } else {
                        Label("Add Project", systemImage: "plus")
                    }
                }
            }
        }
    }
    
    var sortOrderToolBarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                showingSortOrder.toggle()
            } label: {
                Label("Sort", systemImage: "arrow.up.arrow.down")
            }
        }
    }
    
    var body: some View {
        NavigationView {
            Group {
                if projects.wrappedValue.isEmpty {
                    Text("There is nothing here right now")
                        .foregroundColor(.secondary)
                } else {
                    projectListView
                }
            }
            .navigationTitle(showClosedProjects ? "Closed Projects" : "Open Projects")
            .toolbar {
                addProjectToolBarItem
                sortOrderToolBarItem
            }
            .actionSheet(isPresented: $showingSortOrder) {
                ActionSheet(title: Text("Sort items"), message: nil, buttons: [
                    .default(Text("Optimised")) { sortOrder = .optimised },
                    .default(Text("Creation Date")) { sortOrder = .creationDate },
                    .default(Text("Title")) { sortOrder = .title }
                ])
            }
            
            SelectSomethingView()
        }
    }
    
    func onDelete(_ offsets: IndexSet, from project: Project) {
        let allItems = project.projectItems(using: sortOrder)
        
        for offset in offsets {
            let item = allItems[offset]
            dataController.delete(item)
        }
        dataController.save()
    }
    
    func addItem(to project: Project) {
        withAnimation {
            let item = Item(context: managedObjectContext)
            item.project = project
            item.creationDate = Date()
            dataController.save()
        }
    }
    
    func addProject() {
        withAnimation {
            let project = Project(context: managedObjectContext)
            project.closed = false
            project.creationDate = Date()
            dataController.save()
        }
    }
}

struct ProjectsView_Previews: PreviewProvider {
    static var dataController = DataController()
    
    static var previews: some View {
        ProjectsView(showClosedProjects: false)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
