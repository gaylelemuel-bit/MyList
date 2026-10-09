//
//  TaskGroupDetailView.swift
//  MyList
//
//  Created by Lemuel Gayle on 10/3/26.
//

import SwiftUI
import PencilKit

struct TaskGroupDetailView: View {
    @Binding var group: TaskGroup
    @Environment(\.horizontalSizeClass) var sizeClass
    @State private var isShowingAddTask = false
    
    var body: some View {
        List {
            Section{
                if sizeClass == .regular {
                    GroupStatsView(tasks: group.tasks)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color(
                        .secondarySystemBackground))
                }
            }
            ForEach($group.tasks) { $task in
                HStack {
                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                        .foregroundStyle(task.isCompleted ? .green : .gray)
                        .onTapGesture {
                            withAnimation{
                                task.isCompleted.toggle()
                            }
                        }
                    if let data = task.drawingData, let drawing = try? PKDrawing(data: data) {
                        Image(uiImage: drawing.image(from: drawing.bounds, scale: 2))
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 80)
                            .padding(6)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .opacity(task.isCompleted ? 0.4 : 1)
                    } else {
                        TextField("Task title", text: $task.title)
                            .strikethrough(task.isCompleted)
                            .foregroundStyle(task.isCompleted ? .gray : .primary)
                    }
                }
            }
            .onDelete{ index in
                group.tasks.remove(atOffsets: index)
            }
        }
        .navigationTitle(group.title)
        .toolbar {
            Button("Add Task"){
                isShowingAddTask = true
            }
        }
        .sheet(isPresented: $isShowingAddTask) {
            NewTaskView { newTask in
                withAnimation {
                    group.tasks.append(newTask)
                }
            }
        }
    }
}
