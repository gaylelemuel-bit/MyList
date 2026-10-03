//
//  ContentView.swift
//  MyList
//
//  Created by Lemuel Gayle on 10/3/26.
//

import SwiftUI

struct ContentView: View {
    @State private var taskGroups = TaskGroup.sampleData
    @State private var selectGroup: TaskGroup?
    @State private var columnVisibility: NavigationSplitViewVisibility = .all
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            List(selection:$selectGroup) {
                ForEach(taskGroups) { group in
                    NavigationLink(value: group) {
                        Label(group.title, systemImage: group.symbolName)
                    }
                }
                .navigationTitle("Task Groups")
                .listStyle(.sidebar)
            }
        } detail: {
            if let group = selectGroup {
                if let index = taskGroups.firstIndex(where: { $0.id == group.id}) {
                    TaskGroupDetailView(group: $taskGroups[index])
                }
            } else {
                ContentUnavailableView("Select group", systemImage: "sidebar.left")
            }
        }
    }
}

//#Preview {
    //ContentView()
//}
