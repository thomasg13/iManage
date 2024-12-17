import SwiftUI

struct MainPageView: View {
    @State private var progress: Double = 0.0
    @State private var isAddingTask = false
    @State private var tasks: [Task] = []
    @State private var taskBeingEdited: Task? = nil
    @State private var sortOption: SortOption = .none

    enum SortOption: String, CaseIterable {
        case none = "None"
        case color = "Color"
        case dueDate = "Due Date"
        case timeTaken = "Time Taken"
    }
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 12) {
                Text("My Tasks")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 20)
                
                HStack {
                    Text("Work Complete")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                    Text("\(calculateCompletionPercentage())% Complete")
                        .font(.subheadline)
                        .foregroundColor(.orange)
                }
                
                ProgressView(value: calculateProgress())
                    .progressViewStyle(ThickProgressViewStyle(height: 30,  tint: Color.orange))
                    .padding(.trailing)
            }
            .padding(.horizontal)
            
            //sorting
            Menu {
                ForEach(SortOption.allCases, id: \.self) { option in
                    Button(action: {
                        sortOption = option
                        sortTasks()
                    }) {
                        Text(option.rawValue)
                    }
                }
            } label: {
                HStack {
                    Text("Sort by: \(sortOption.rawValue)")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                    Image(systemName: "chevron.down")
                }
                .padding(.horizontal)
            }
            
            
            List {
                ForEach(tasks) { task in
                    HStack {
                        Capsule(style: RoundedCornerStyle.continuous)
                            .fill(task.color)
                            .frame(width: 10, height: .infinity)
                                
                        Button(action: {
                            toggleTaskCompletion(task)
                        }) {
                            Image(systemName: task.isCompleted ? "checkmark.square.fill" : "square")
                                .foregroundColor(task.isCompleted ? .green : .gray)
                        }
                            
                        VStack(alignment: .leading) {
                            HStack {
                                Text(task.name)
                                    .strikethrough(task.isCompleted, color: .gray)
                                    .foregroundColor(task.isCompleted ? .gray : .primary)
                                    .font(.headline)
                                Text(task.estimateTime)
                                    .bold()
                                    .foregroundColor(task.color)
                            }
                                
                            Text(task.dueDate, style: .date)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                        
                    .padding()
                    .frame(maxWidth: .infinity)
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
                .listStyle(.sidebar)
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
    
    private func sortTasks() {
        switch sortOption {
        case .none:
            break;
        case .color:
            tasks.sort { $0.color.description < $1.color.description }
        case .dueDate:
            tasks.sort { $0.dueDate < $1.dueDate }
        case .timeTaken:
            tasks.sort { $0.estimateTime < $1.estimateTime }
        }
    }
    
    private func calculateCompletionPercentage() -> Int {
        let completedTasks = tasks.filter { $0.isCompleted }.count
        let totalTasks = tasks.count
        guard totalTasks > 0 else { return 0 }
        return Int((Double(completedTasks) / Double(totalTasks)) * 100)
    }
}

struct AddTaskView: View {
    @Binding var isPresented: Bool
    @Binding var tasks: [Task]
    @State private var taskName = ""
    @State private var dueDate = Date()
    @State private var selectedColor = Color.blue
    @State private var taskEstimateTime = ""
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Task Name", text: $taskName)
                
                DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                
                TextField("Estimate Time (In Minutes)", text: $taskEstimateTime)
                
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
                        let newTask = Task(name: taskName, dueDate: dueDate, color: selectedColor, estimateTime: taskEstimateTime)
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
                
                TextField("Estimate Time", text: $task.estimateTime)
                
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
    var estimateTime: String
}

struct ThickProgressViewStyle: ProgressViewStyle {
    let height: CGFloat
    let tint: Color

    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: height / 2)
                    .frame(height: height)
                    .foregroundColor(tint.opacity(0.3))

                RoundedRectangle(cornerRadius: height / 2)
                    .frame(width: CGFloat(configuration.fractionCompleted ?? 0) * geometry.size.width,
                           height: height)
                .foregroundColor(tint)
            }
        }
        .frame(height: height)
    }
}

#Preview {
    MainPageView()
}
