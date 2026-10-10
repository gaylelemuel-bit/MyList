//
//  ContentView.swift
//  MyList
//
//  Created by Lemuel Gayle on 10/3/26.
//

import SwiftUI

struct ContentView: View {
    //@Binding var isDarkMode: Bool
    @State private var taskGroups: [TaskGroup] = []
    @State private var selectGroup: TaskGroup?
    @State private var columnVisibility: NavigationSplitViewVisibility = .all
    
    @State private var isShowingAddGroup = false
    @Environment(\.scenePhase) private var scenePhase
    let saveKey = "SaveTaskGroups"
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            List(selection:$selectGroup) {
                ForEach(taskGroups) { group in
                    NavigationLink(value: group) {
                        Label(group.title, systemImage: group.symbolName)
                    }
                }
            }
                .navigationTitle("Task Groups")
                .listStyle(.sidebar)
                .toolbar {
                    Button {
                        isShowingAddGroup = true
                    } label: {
                        Image(systemName: "plus")
                    }
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
            .sheet(isPresented: $isShowingAddGroup){
                NewGroupVew { newGroup in
                    taskGroups.append(newGroup)
                    selectGroup = newGroup
                }
            }
            .onAppear{
                loadData()
            }
            .onChange(of: scenePhase) { oldValue, newValue in
                if newValue == .active {
                    print("App is active")
                } else if newValue == .inactive {
                    
                }else if newValue == .background {
                    saveData()
                    print("app is in background - save data ")
                }
            }
        }
    func saveData() {
        if let encodedData = try? JSONEncoder().encode(taskGroups){
            UserDefaults.standard.set(encodedData, forKey: saveKey)
        }
    }
    func loadData () {
        if let savedData = UserDefaults.standard.data(forKey: saveKey){
            if let decodedGroups = try? JSONDecoder().decode([TaskGroup].self, from: savedData){
                taskGroups = decodedGroups
                return
            }
        }
        taskGroups = TaskGroup.sampleData
    }
    }
//#Preview {
    //ContentView()
//}
