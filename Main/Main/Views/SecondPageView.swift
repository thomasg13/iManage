import SwiftUI

struct SecondPageView: View {
    @State private var workoutSchedule = WorkoutSchedule()
    @State private var selectedWorkoutDay: WorkoutDay? = nil
    @State private var selectedDate: Date = Date() // Track the selected date

    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
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
                        .padding(10)
                    }
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal, 10)
                }

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
            .padding(.top, 20)
            .onAppear {
                workoutSchedule.generateSchedule() // Generate schedule on load
                // Set the default selected day to the current date
                if let today = workoutSchedule.days.first(where: { Calendar.current.isDate($0.date, inSameDayAs: Date()) }) {
                    selectedWorkoutDay = nil // Ensure it doesn't navigate to the detail page
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
}

#Preview {
    SecondPageView()
}
