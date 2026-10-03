//
//  TaskModels.swift
//  MyList
//
//  Created by Lemuel Gayle on 10/3/26.
//

import Foundation

struct TaskItem: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var isCompleted: Bool = false
}

struct TaskGroup: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var symbolName: String
    var tasks: [TaskItem]
}

//Mock Data
extension TaskGroup {
    static let sampleData: [TaskGroup] = [
        TaskGroup(title: "School", symbolName: "book.fill", tasks: [
            TaskItem(title: "Grade Assignments"),
            TaskItem(title: "Do dissussions")
        ]),
        
        TaskGroup(title: "Home", symbolName: "house.fill", tasks: [
            TaskItem(title: "Get groceries", isCompleted: true),
            TaskItem(title: "Walk for 30 mins")
        ])
    ]
}
