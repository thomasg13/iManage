import SwiftUI

struct MainPageView: View {
    @State private var progress: Double = 0.0
    @State private var isAddingTask = false
    @State private var tasks: [Task] = []
    @State private var taskBeingEdited: Task? = nil

    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("My Tasks")
                    .font(.largeTitle)
                    .bold()
                
                Text("Work Complete")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                ProgressView(value: calculateProgress())
                    .progressViewStyle(LinearProgressViewStyle(tint: Color.orange))
                    .padding(.trailing)
            }
            .padding(.horizontal)

            List {
                ForEach(tasks) { task in
                    HStack {
                        Button(action: {
                            toggleTaskCompletion(task)
                        }) {
                            Image(systemName: task.isCompleted ? "checkmark.square.fill" : "square")
                                .foregroundColor(task.isCompleted ? .green : .gray)
                        }
                        
                        VStack(alignment: .leading) {
                            Text(task.name)
                                .strikethrough(task.isCompleted, color: .gray)
                                .foregroundColor(task.isCompleted ? .gray : .primary)
                                .font(.headline)
                            Text(task.dueDate, style: .date)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .background(task.color.opacity(0.2))
                    .cornerRadius(8)
                    .swipeActions {
                        Button(role: .destructive) {
                            deleteTask(task)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }

                        Button {
                            editTask(task)
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.blue)
                    }
                }
            }
            .listStyle(PlainListStyle())
            .sheet(item: $taskBeingEdited) { task in
                EditTaskView(task: $tasks[tasks.firstIndex(where: { $0.id == task.id })!])
            }
            
            Spacer()
        }
        .background(Color(UIColor.systemGroupedBackground))
        .overlay(
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        isAddingTask.toggle()
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Color.blue)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                            .padding()
                    }
                }
            }
        )
        .sheet(isPresented: $isAddingTask) {
            AddTaskView(isPresented: $isAddingTask, tasks: $tasks)
        }
    }

    private func toggleTaskCompletion(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
        }
    }

    private func calculateProgress() -> Double {
        let completedTasks = tasks.filter { $0.isCompleted }.count
        return tasks.isEmpty ? 0.0 : Double(completedTasks) / Double(tasks.count)
    }

    private func deleteTask(_ task: Task) {
        tasks.removeAll { $0.id == task.id }
    }

    private func editTask(_ task: Task) {
        print("Edit task: \(task.name)")
        taskBeingEdited = task
    }
}

struct AddTaskView: View {
    @Binding var isPresented: Bool
    @Binding var tasks: [Task]
    @State private var taskName = ""
    @State private var dueDate = Date()
    @State private var selectedColor = Color.blue
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Task Name", text: $taskName)
                
                DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                
                ColorPicker("Task Color", selection: $selectedColor)
            }
            .navigationTitle("Add New Task")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let newTask = Task(name: taskName, dueDate: dueDate, color: selectedColor)
                        tasks.append(newTask)
                        isPresented = false
                    }
                    .disabled(taskName.isEmpty)
                }
            }
        }
    }
}

struct EditTaskView: View {
    @Binding var task: Task
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            Form {
                TextField("Task Name", text: $task.name)

                DatePicker("Due Date", selection: $task.dueDate, displayedComponents: .date)

                ColorPicker("Task Color", selection: $task.color)
            }
            .navigationTitle("Edit Task")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}


struct Task: Identifiable {
    let id = UUID()
    var name: String
    var dueDate: Date
    var isCompleted = false
    var color:Color = .blue
}

#Preview {
    MainPageView()
}
