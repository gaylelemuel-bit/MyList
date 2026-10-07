//
//  NewGroupVew.swift
//  MyList
//
//  Created by Lemuel Gayle on 10/6/26.
//

import SwiftUI

struct NewGroupVew: View{
    @Environment(\.dismiss) var dismiss
    @State private var groupName = ""
    @State private var selectedIcon = "list.bullet"
    let icons = ["list.bullet","star.fill","heart.fill","graduationcap.fill","house.fill"]
    
    var onSave:(TaskGroup) -> Void
    
    var body: some View {
        NavigationStack{
            Form {
                //Sect1 = group name
                Section("Group Name"){
                    TextField("Enter the nmae of your group", text:
                    $groupName)
                }
                //sect2= icon picker
                Section("Select Icon"){
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))])
                    {
                        ForEach(icons, id: \.self) {icon in
                            Image(systemName: icon)
                                .font(.title2)
                                .frame(width: 40 , height: 40)
                                .background(selectedIcon == icon ? Color.blue.opacity(0.2) : Color.clear)
                                .foregroundStyle(selectedIcon == icon ? Color.green : Color.gray)
                                .clipShape(Circle())
                                .onTapGesture{
                                    selectedIcon = icon
                                }
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("New Group")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel"){ dismiss ()}
                }
                ToolbarItem(placement: .confirmationAction){
                    Button("Save"){
                        let newGroup = TaskGroup(title: groupName, symbolName: selectedIcon, tasks: [])
                        onSave(newGroup)
                        dismiss()
                    }
                    .disabled(groupName.isEmpty)
                }
            }
        }
    }
}
