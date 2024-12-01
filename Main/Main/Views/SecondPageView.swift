import SwiftUI

struct SecondPageView: View {
    @State private var workoutSchedule = WorkoutSchedule()
    @State private var selectedWorkoutDay: WorkoutDay? = nil

    var body: some View {
        VStack {
            Text("My Workout Schedule")
                .font(.largeTitle)
                .bold()
                .padding()

            // Calendar View (list of all workout days)
            List {
                ForEach(workoutSchedule.days, id: \.id) { workoutDay in
                    HStack {
                        Text(formattedDate(workoutDay.date))
                            .frame(width: 100, alignment: .leading)

                        Text(workoutDay.type)
                            .frame(width: 120)

                        Spacer()

                        // Button to navigate to the workout details for the day
                        Button(action: {
                            self.selectedWorkoutDay = workoutDay
                        }) {
                            Text("View Workout")
                        }
                        .sheet(item: $selectedWorkoutDay) { workoutDay in
                            WorkoutDetailView(workoutDay: workoutDay)
                        }
                    }
                }
            }
            .onAppear {
                workoutSchedule.generateSchedule() // Generate the workout schedule
            }

            // Button to add exercises (this would navigate to an 'AddExerciseView')
            Button(action: {
                // Navigation to the AddExerciseView where users can add new exercises
                print("Add new exercise")
            }) {
                Text("Add Exercise")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
        }
        .padding()
    }

    // Utility function to format the date
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd" // E.g., Dec 02
        return formatter.string(from: date)
    }
}

#Preview {
    SecondPageView()
}
