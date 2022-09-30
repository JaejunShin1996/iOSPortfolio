//
//  ProjectsView.swift
//  JaejunShinPortfolio
//
//  Created by Jaejun Shin on 10/8/2022.
//

import SwiftUI

struct ProjectsView: View {
    static let openTag: String? = "Open"
    static let closedTag: String? = "Closed"

    @StateObject var viewModel: ViewModel

    init(dataController: DataController, showClosedProjects: Bool) {
        let viewModel = ViewModel(dataController: dataController, showClosedProjects: showClosedProjects)

        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var projectListView: some View {
        List(selection: $viewModel.selectedItem) {
            ForEach(viewModel.projects) { project in
                Section(header: ProjectHeaderView(project: project)) {
                    ForEach(project.projectItems(using: viewModel.sortOrder)) { item in
                        ItemRowView(project: project, item: item)
                            .contextMenu {
                                Button("Delete", role: .destructive) {
                                    viewModel.delete(item)
                                }
                            }
                            .tag(item)
                    }
                    .onDelete { offsets in
                        withAnimation {
                            viewModel.onDelete(offsets, from: project)
                        }
                    }

                    if viewModel.showClosedProjects == false {
                        Button {
                            withAnimation {
                                viewModel.addItem(to: project)
                            }
                        } label: {
                            Label("Add New Item", systemImage: "plus")
                        }
                        .buttonStyle(ImageButtonStyle())
                    }
                }
                .disableCollapsing()
            }
        }
        .listStyle(InsetGroupedListStyle())
        .onDeleteCommand {
            guard let selectedItem = viewModel.selectedItem else { return }
            viewModel.delete(selectedItem)
        }
    }

    var addProjectToolBarItem: some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            if viewModel.showClosedProjects == false {
                Button {
                    withAnimation {
                        viewModel.addProject()
                    }
                } label: {
                    Label("Add Project", systemImage: "plus")
                }
            }
        }
    }

    var sortOrderToolBarItem: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Menu {
                Button("Optimised") { viewModel.sortOrder = .optimised }
                Button("Creation Date") { viewModel.sortOrder = .creationDate }
                Button("Title") { viewModel.sortOrder = .title }
            } label: {
                Label("Sort", systemImage: "arrow.up.arrow.down")
            }
        }
    }

    var body: some View {
        NavigationView {
            Group {
                if viewModel.projects.isEmpty {
                    Text("There is nothing here right now")
                        .foregroundColor(.secondary)
                } else {
                    projectListView
                }
            }
            .navigationTitle(viewModel.showClosedProjects ? "Closed Projects" : "Open Projects")
            .toolbar {
                addProjectToolBarItem
                sortOrderToolBarItem
            }

            SelectSomethingView()
        }
        .sheet(isPresented: $viewModel.showingUnlockView) {
            UnlockView()
        }
    }
}

struct ProjectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectsView(dataController: DataController.preview, showClosedProjects: false)
    }
}
