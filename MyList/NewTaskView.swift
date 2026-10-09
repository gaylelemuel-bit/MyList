//
//  NewTaskView.swift
//  MyList
//
//  Created by Lemuel Gayle on 10/9/26.

import SwiftUI
import PencilKit

struct NewTaskView: View {
    enum InputMode: String, CaseIterable, Identifiable {
        case type = "Type"
        case draw = "Draw"
        var id: String { rawValue }
    }

    @Environment(\.dismiss) var dismiss
    @State private var inputMode: InputMode = .type
    @State private var title = ""
    @State private var canvasView = PKCanvasView()
    @State private var hasDrawing = false

    var onSave: (TaskItem) -> Void

    private var canSave: Bool {
        switch inputMode {
        case .type:
            return !title.trimmingCharacters(in: .whitespaces).isEmpty
        case .draw:
            return hasDrawing
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("Input", selection: $inputMode) {
                    ForEach(InputMode.allCases) { mode in
                        Text(mode.rawValue).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
                .padding()

                switch inputMode {
                case .type:
                    Form {
                        TextField("Enter your task", text: $title)
                    }
                case .draw:
                    HStack(spacing: 20) {
                        Button(action: clearCanvas) {
                            Label("Clear", systemImage: "trash")
                        }
                        .keyboardShortcut("t", modifiers: .command)
                        Spacer()
                        Button(action: undo) {
                            Label("Undo", systemImage: "arrow.uturn.backward")
                        }
                        .keyboardShortcut("z", modifiers: .command)
                        Button(action: redo) {
                            Label("Redo", systemImage: "arrow.uturn.forward")
                        }
                        .keyboardShortcut("r", modifiers: .command)
                    }
                    .labelStyle(.iconOnly)
                    .padding(.horizontal)
                    .padding(.bottom, 8)

                    CanvasView(canvasView: $canvasView) { hasStrokes in
                        hasDrawing = hasStrokes
                    }
                }
            }
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: save)
                        .disabled(!canSave)
                }
            }
        }
    }

    private func save() {
        let newTask: TaskItem
        switch inputMode {
        case .type:
            newTask = TaskItem(title: title.trimmingCharacters(in: .whitespaces))
        case .draw:
            newTask = TaskItem(title: "", drawingData: canvasView.drawing.dataRepresentation())
        }
        onSave(newTask)
        dismiss()
    }

    private func clearCanvas() {
        canvasView.drawing = PKDrawing()
        hasDrawing = false
    }

    private func undo() {
        canvasView.undoManager?.undo()
    }

    private func redo() {
        canvasView.undoManager?.redo()
    }
}
