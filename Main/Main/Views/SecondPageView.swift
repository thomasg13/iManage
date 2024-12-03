import SwiftUI
import Charts

struct SecondPageView: View {
    @State private var workoutSchedule = WorkoutSchedule()
    @State private var selectedWorkoutDay: WorkoutDay? = nil
    @State private var selectedDate: Date = Date() // Track the selected date
    @State private var selectedExercise: String = "Squats" // Default exercise
    @State private var exerciseData: [ExerciseData] = generateSampleData(for: "Squats") // Sample data

    let exercises = ["Squats", "Bench Press", "Deadlift", "Pull Ups", "Chest Fly"]

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Weekly Calendar at the top
                VStack(spacing: 15) {
                    Text("Weekly Calendar")
                        .font(.title2)
                        .bold()

                    // Horizontal Calendar
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(workoutSchedule.days, id: \.id) { workoutDay in
                                VStack {
                                    Text(formattedDay(workoutDay.date))
                                        .font(.subheadline)
                                        .foregroundColor(.gray)

                                    Text(formattedDate(workoutDay.date))
                                        .font(.headline)
                                        .bold()
                                        .foregroundColor(selectedDate == workoutDay.date ? .white : .black)
                                        .frame(width: 40, height: 40)
                                        .background(
                                            Circle()
                                                .foregroundColor(selectedDate == workoutDay.date ? .blue : .clear)
                                        )
                                        .onTapGesture {
                                            selectedWorkoutDay = workoutDay
                                            selectedDate = workoutDay.date
                                        }
                                }
                            }
                        }
                        .padding(.horizontal, 15)
                        .padding(.vertical, 10)
                    }
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                }

                // Exercise Progress Graph
                VStack(spacing: 20) {
                    Text("Exercise Progress")
                        .font(.headline)

                    Picker("Select Exercise", selection: $selectedExercise) {
                        ForEach(exercises, id: \.self) { exercise in
                            Text(exercise).tag(exercise)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: selectedExercise) { newValue in
                        exerciseData = SecondPageView.generateSampleData(for: newValue) // Update chart data
                    }

                    ExerciseProgressChart(data: exerciseData)
                }
                .padding(.horizontal, 20)

                Spacer()

                // Automatically navigate to the Workout Details view when a date is selected
                NavigationLink(
                    destination: WorkoutDetailView(
                        workoutDay: Binding(
                            get: { selectedWorkoutDay ?? WorkoutDay(date: Date(), type: "Rest", exercises: []) },
                            set: { updatedWorkoutDay in
                                if let index = workoutSchedule.days.firstIndex(where: { $0.id == updatedWorkoutDay.id }) {
                                    workoutSchedule.days[index] = updatedWorkoutDay
                                }
                                selectedWorkoutDay = updatedWorkoutDay
                            }
                        )
                    ),
                    isActive: Binding(
                        get: { selectedWorkoutDay != nil },
                        set: { if !$0 { selectedWorkoutDay = nil } }
                    )
                ) {
                    EmptyView()
                }
            }
            .padding(.top, 30)
            .onAppear {
                workoutSchedule.generateSchedule() // Generate schedule on load
                if let today = workoutSchedule.days.first(where: { Calendar.current.isDate($0.date, inSameDayAs: Date()) }) {
                    selectedWorkoutDay = nil
                    selectedDate = today.date
                }
            }
        }
    }

    // Helper to format the date
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d" // Day of the month
        return formatter.string(from: date)
    }

    // Helper to format the day (e.g., Sun, Mon)
    private func formattedDay(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E" // Day of the week
        return formatter.string(from: date)
    }

    // Sample data generator for demonstration
    static func generateSampleData(for exercise: String, includeToday: Bool = true) -> [ExerciseData] {
        let startDate = Calendar.current.date(byAdding: .day, value: -30, to: Date())!
        var data: [ExerciseData] = []

        // Generate data for the last 30 days
        for day in 0..<30 {
            let date = Calendar.current.date(byAdding: .day, value: day, to: startDate)!
            let weight = Double(100 + (day * 2)) // Simulated weight progression
            data.append(ExerciseData(date: date, weight: weight))
        }

        // Include today's data if needed
        if includeToday {
            let today = Date()
            let todayWeight = Double(160) // Simulated today's weight, replace with real data logic
            if let lastEntry = data.last, !Calendar.current.isDate(lastEntry.date, inSameDayAs: today) {
                data.append(ExerciseData(date: today, weight: todayWeight))
            } else if var lastEntry = data.last {
                // Update today's entry if it already exists
                lastEntry.weight = todayWeight
                data[data.count - 1] = lastEntry
            }
        }

        return data
    }
}


#Preview {
    SecondPageView()
}
