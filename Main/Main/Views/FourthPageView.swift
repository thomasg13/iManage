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

            Text("Logged Data")
                .font(.headline)
                .padding(.leading)
            
            VStack(alignment: .leading) {

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
                                Text("Amount: \(task.amount) \(unit(for: task.type))")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
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
    
    private func unit(for type: String) -> String {
        switch type {
        case "Water Drinking":
            return "mL"
        case "Food Intake":
            return "cal"
        case "Exercise":
            return "min"
        case "Reading":
            return "pages"
        default:
            return type
        }
    }
}

struct CircularProgressBar: View {
    var progress: Double
    var lineWidth: CGFloat = 20
    var barColor: Color = .blue
    var backgroundColor: Color = .gray.opacity(0.2)
    var text: String = "Water"
    @State private var isSpinning = false
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .foregroundColor(backgroundColor)
            Circle()
                .trim(from: 0.0, to: progress)
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .foregroundColor(barColor)
                .shadow(color: barColor.opacity(0.5), radius: 10, x: 0, y: 0)
                .shadow(color: barColor.opacity(0.3), radius: 15, x: 0, y: 0)
                .shadow(color: barColor.opacity(0.1), radius: 20, x: 0, y: 0)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 1.0), value: progress)
            
            .rotationEffect(.degrees(isSpinning ? 360 : 0))
            .animation(isSpinning ? Animation.linear(duration: 2).repeatForever(autoreverses: false) : .none, value: isSpinning)
            
            VStack {
                if progress == 1.0 {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.green)
                        .onAppear {
                            isSpinning = true
                        }
                } else {
                    Text("\(Int(progress * 100))%")
                        .font(.title3)
                        .bold()
                        .foregroundColor(barColor)
                        .shadow(color: barColor.opacity(0.8), radius: 5, x: 0, y: 0)
                }
                Text(text)
                    .font(.headline)
                    .foregroundColor(barColor)
                    .bold()
                    .shadow(color: barColor.opacity(0.5), radius: 5, x: 0, y: 0)
            }
        }
        .padding(lineWidth / 2)
        .frame(width: 150, height: 150)
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
    @State private var showAlert = false
    
    let taskTypes = ["Water Drinking", "Food Intake", "Exercise", "Reading"]
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Activity Name", text: $name)
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
        guard let amountValue = Double(amount), amountValue >= 0 else {
            showAlert = true
            return
        }
        
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
    @State private var showAlert = false // State variable for alert

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
                            .onChange(of: waterGoal) { newValue in
                                if newValue < 0 {
                                    waterGoal = 0
                                    showAlert = true
                                }
                            }
                    }


                    HStack {
                        Text("Calorie Goal (cal)")
                        Spacer()
                        TextField("Calories", value: $calorieGoal, format: .number)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onChange(of: calorieGoal) { newValue in
                                if newValue < 0 {
                                    calorieGoal = 0
                                    showAlert = true
                                }
                            }
                    }

                    HStack {
                        Text("Exercise Goal (minutes)")
                        Spacer()
                        TextField("Exercise", value: $exerciseGoal, format: .number)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onChange(of: exerciseGoal) { newValue in
                                if newValue < 0 {
                                    exerciseGoal = 0
                                    showAlert = true
                                }
                            }
                    }

                    HStack {
                        Text("Reading Goal (pages)")
                        Spacer()
                        TextField("Pages", value: $pageGoal, format: .number)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onChange(of: pageGoal) { newValue in
                                if newValue < 0 {
                                    pageGoal = 0
                                    showAlert = true
                                }
                            }
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
        .alert("Invalid Input", isPresented: $showAlert) { // Add the alert here
            Button("OK", role: .cancel) {}
        } message: {
            Text("Goals cannot be negative. Please enter a positive value.")
        }
    }
}



#Preview {
    FourthPageView()
}
