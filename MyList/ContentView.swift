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
    @Binding var profile: Profile
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            List(selection:$selectGroup) {
                ForEach(profile.groups) { group in
                    NavigationLink(value: group) {
                        Label(group.title, systemImage: group.symbolName)
                    }
                }
            }
            .navigationTitle(profile.name)
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
                    if let index = profile.groups.firstIndex(where: { $0.id == group.id}) {
                        TaskGroupDetailView(group: $profile.groups[index])
                    }
                } else {
                    ContentUnavailableView("Select group", systemImage: "sidebar.left")
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $isShowingAddGroup){
                NewGroupVew { newGroup in
                    profile.groups.append(newGroup)
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
        if let encodedData = try? JSONEncoder().encode(profile.groups){
            UserDefaults.standard.set(encodedData, forKey: saveKey)
        }
    }
    func loadData () {
        if let savedData = UserDefaults.standard.data(forKey: saveKey){
            if let decodedGroups = try? JSONDecoder().decode([TaskGroup].self, from: savedData){
                profile.groups = decodedGroups
                return
            }
        }
        profile.groups = TaskGroup.sampleData
    }
    }
//#Preview {
    //ContentView()
//}
