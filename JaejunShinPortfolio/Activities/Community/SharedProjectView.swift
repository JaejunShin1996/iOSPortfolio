//
//  SharedProjectView.swift
//  JaejunShinPortfolio
//
//  Created by Jaejun Shin on 21/9/2022.
//

import CloudKit
import SwiftUI

struct SharedProjectView: View {
    static let tag: String? = "Community"

    @State private var projects = [SharedProject]()
    @State private var loadState = LoadState.inactive
    @State private var cloudError: CloudError?

    var body: some View {
        NavigationView {
            Group {
                switch loadState {
                case .inactive, .loading:
                    ProgressView()
                case .noResults:
                    VStack {
                        Text("No Results")

                        Button {
                            fetchSharedProjects()
                        } label: {
                            Text("Try again")
                        }
                    }
                case .success:
                    List(projects) { project in
                        NavigationLink(destination: SharedItemView(project: project)) {
                            VStack(alignment: .leading) {
                                Text(project.title)
                                    .font(.headline)

                                Text(project.owner)
                            }
                        }
                    }
                    .listStyle(InsetListStyle())
                }
            }
            .navigationTitle("Shared Projects")
        }
        .onAppear(perform: fetchSharedProjects)
        .alert(item: $cloudError) { error in
            Alert(
                title: Text("There was an error."),
                message: Text(error.localizedMessage)
            )
        }
    }

    func fetchSharedProjects() {
        guard loadState == .inactive || loadState == .noResults else { return }
        loadState = .loading

        let pred = NSPredicate(value: true)
        let sort = NSSortDescriptor(key: "creationDate", ascending: false)
        let query = CKQuery(recordType: "Project", predicate: pred)
        query.sortDescriptors = [sort]

        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["title", "detail", "owner", "closed"]
        operation.resultsLimit = 50
        operation.recordMatchedBlock = { recordID, result in
            switch result {
            case .success(let record):
                let id = recordID.recordName
                let title = record["title"] as? String ?? "No Title"
                let detail = record["detail"] as? String ?? "No Detail"
                let owner = record["owner"] as? String ?? "No Owner"
                let closed = record["closed"] as? Bool ?? false

                let sharedProject = SharedProject(id: id, title: title, detail: detail, owner: owner, closed: closed)
                projects.append(sharedProject)
                loadState = .success
            case .failure(let error):
                cloudError = error.getCloudKitError()
                loadState = .noResults
                print("debug: \(error.localizedDescription)")
            }
        }

        operation.queryResultBlock = { result in
            switch result {
            case .success(let cursor):
                print("\(String(describing: cursor?.description))")
            case .failure(let error):
                print("debug: \(error.localizedDescription)")
                cloudError = error.getCloudKitError()
                loadState = .noResults
            }
        }

        CKContainer.default().publicCloudDatabase.add(operation)
    }
}

struct SharedProjectView_Previews: PreviewProvider {
    static var previews: some View {
        SharedProjectView()
    }
}
