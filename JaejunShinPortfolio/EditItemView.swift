//
//  EditView.swift
//  JaejunShinPortfolio
//
//  Created by Jaejun Shin on 14/8/2022.
//

import SwiftUI

struct EditView: View {
    @EnvironmentObject var dataController: DataController
    
    var item: Item
    
    @State private var title: String
    @State private var detail: String
    @State private var priority: Int
    @State private var completion: Bool
    
    init(item: Item) {
        self.item = item
        
        _title = State(wrappedValue: item.itemTitle)
        _detail = State(wrappedValue: item.itemDetail)
        _priority = State(wrappedValue: Int(item.priority))
        _completion = State(wrappedValue: item.completion)
    }
    
    var body: some View {
        Form {
            Section(header: Text("Basic Settings")) {
                TextField("Title", text: $title.onChange(update))
                TextField("Description", text: $detail.onChange(update))
            }
            
            Section(header: Text("Priority")) {
                Picker("Priority", selection: $priority.onChange(update)) {
                    Text("Low").tag(1)
                    Text("Medium").tag(2)
                    Text("High").tag(3)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            Section {
                Toggle("Completed", isOn: $completion.onChange(update))
            }
        }
        .navigationTitle("Edit View")
        .onDisappear(perform: dataController.save)
    }
    
    func update() {
        item.project?.objectWillChange.send()
        
        item.title = title
        item.detail = detail
        item.priority = Int16(priority)
        item.completion = completion
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(item: Item.example)
    }
}
