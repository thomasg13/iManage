import SwiftUI

struct LogTask: Identifiable {
    let id = UUID()
    let name: String
    let type: String
    let amount: String
    let color: Color
}

struct FourthPageView: View {
    @State private var waterGoal: Double = 2000
    @State private var calorieGoal: Double = 2000
    @State private var pageGoal: Double = 10
    @State private var exerciseGoal: Double = 45

    @State private var isEditingGoals = false
    @State private var isLoggingData = false

    @State private var waterAmount: Double = 0
    @State private var calorieAmount: Double = 0
    @State private var pageAmount: Double = 0
    @State private var exerciseAmount: Double = 0

    @State private var tasks: [LogTask] = []

    var body: some View {
        VStack {
            Text("Daily Goals")
                .font(.largeTitle)
                .bold()
                .padding(.top, 20)

            HStack {
                CircularProgressBar(progress: calculatePercentage(current: waterAmount, goal: waterGoal), lineWidth: 15, barColor: .blue, text: "Water")
                    .frame(width: 150, height: 150)
                CircularProgressBar(progress: calculatePercentage(current: calorieAmount, goal: calorieGoal), lineWidth: 15, barColor: .yellow, text: "Calories")
                    .frame(width: 150, height: 150)
            }
            HStack {
                CircularProgressBar(progress: calculatePercentage(current: pageAmount, goal: pageGoal), lineWidth: 15, barColor: .green, text: "Books")
                    .frame(width: 150, height: 150)
                CircularProgressBar(progress: calculatePercentage(current: exerciseAmount, goal: exerciseGoal), lineWidth: 15, barColor: .red, text: "Exercise")
                    .frame(width: 150, height: 150)
            }
            HStack {
                Button(action: {
                    isEditingGoals.toggle()
                }) {
                    Text("Change Goals")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                Button(action: {
                    isLoggingData.toggle()
                }) {
                    Text("Log Data")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
            Divider()

            VStack(alignment: .leading) {
                Text("Logged Data")
                    .font(.headline)
                    .padding(.leading)

                ScrollView {
                    ForEach(tasks) { task in
                        HStack {
                            Circle()
                                .fill(task.color)
                                .frame(width: 20, height: 20)
                            VStack(alignment: .leading) {
                                Text("\(task.type): \(task.name)")
                                    .font(.body)
                                    .foregroundColor(.primary)
                                Text("Amount: \(task.amount)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                    }
                }
            }
            .padding(.top)
            Spacer()
        }
        .sheet(isPresented: $isEditingGoals) {
            EditingGoalsView(
                waterGoal: $waterGoal,
                calorieGoal: $calorieGoal,
                exerciseGoal: $exerciseGoal,
                pageGoal: $pageGoal
            )
        }
        .sheet(isPresented: $isLoggingData) {
            LogDataView(
                isPresented: $isLoggingData,
                tasks: $tasks,
                waterAmount: $waterAmount,
                calorieAmount: $calorieAmount,
                pageAmount: $pageAmount,
                exerciseAmount: $exerciseAmount
            )
        }

    }

    private func calculatePercentage(current: Double, goal: Double) -> Double {
        guard goal > 0 else { return 0.0 }
        return min(current / goal, 1.0)
    }
}

struct CircularProgressBar: View {
    var progress: Double
    var lineWidth: CGFloat = 20
    var barColor: Color = .blue
    var backgroundColor: Color = .gray.opacity(0.2)
    var text: String = "Test"

    var body: some View {
        ZStack {
            Circle()
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .foregroundColor(backgroundColor)

            Circle()
                .trim(from: 0.0, to: progress)
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .foregroundColor(barColor)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut, value: progress)

            VStack {
                Text(text)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text("\(Int(progress * 100))%")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(barColor)
            }
        }
        .padding(lineWidth / 2)
    }
}

struct LogDataView: View {
    @Binding var isPresented: Bool
    @Binding var tasks: [LogTask]
    @Binding var waterAmount: Double
    @Binding var calorieAmount: Double
    @Binding var pageAmount: Double
    @Binding var exerciseAmount: Double
    @State private var name = ""
    @State private var amount = ""
    @State private var selectedType = "Water Drinking"
    @State private var selectedColor = Color.blue
    @State private var typeText = ""
    
    let taskTypes = ["Water Drinking", "Food Intake", "Exercise", "Reading"]
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Task Name", text: $name)
                Picker("Select Type", selection: $selectedType) {
                    ForEach(taskTypes, id: \.self) { type in
                        Text(type).tag(type)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                
                TextField(amountText(), text: $amount)
                    .keyboardType(.numberPad)
                
//                ColorPicker("Task Color", selection: $selectedColor)
            }
            .navigationTitle("Log Data")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {

                        saveLog()
                        isPresented = false
                    }
                    .disabled(name.isEmpty || amount.isEmpty)
                }
            }
        }
    }
    private func amountText() -> String {
        switch selectedType {
        case "Water Drinking":
            return "Amount (mL)"
        case "Food Intake":
            return "Amount (calories)"
        case "Exercise":
            return "Amount (minutes)"
        case "Reading":
            return "Amount (pages)"
        default:
            return "Amount"
        }
    }
    private func saveLog() {
        guard let amountValue = Double(amount) else { return }
        let taskColor: Color
        
        switch selectedType {
            case "Water Drinking":
                waterAmount += amountValue
                taskColor = .blue
            case "Food Intake":
                calorieAmount += amountValue
                taskColor = .yellow
            case "Exercise":
                exerciseAmount += amountValue
                taskColor = .red
            case "Reading":
                pageAmount += amountValue
                taskColor = .green
            default:
                taskColor = .gray
        }
        
        let newTask = LogTask(name: name, type: selectedType, amount: amount, color: taskColor)
        tasks.append(newTask)
    }
}



struct EditingGoalsView: View {
    @Binding var waterGoal: Double
    @Binding var calorieGoal: Double
    @Binding var exerciseGoal: Double
    @Binding var pageGoal: Double
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            Text("Set Your Daily Goals")
                .font(.largeTitle)
                .bold()
                .padding()

            Form {
                Section(header: Text("Goals")) {
                    HStack {
                        Text("Water Goal (mL)")
                        Spacer()
                        TextField("Water", value: $waterGoal, format: .number)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }

                    HStack {
                        Text("Calorie Goal (cal)")
                        Spacer()
                        TextField("Calories", value: $calorieGoal, format: .number)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }

                    HStack {
                        Text("Exercise Goal (minutes)")
                        Spacer()
                        TextField("Exercise", value: $exerciseGoal, format: .number)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }

                    HStack {
                        Text("Reading Goal (pages)")
                        Spacer()
                        TextField("Pages", value: $pageGoal, format: .number)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
            }

            Button(action: {
                dismiss()
            }) {
                Text("Save Goals")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
        }
    }
}


#Preview {
    FourthPageView()
}
