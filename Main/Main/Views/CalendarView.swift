import SwiftUI

struct CalendarView: View {
    @State private var workoutSchedule = WorkoutSchedule()

    var body: some View {
        VStack {
            Text("My Workout Schedule")
                .font(.largeTitle)
                .bold()

            List {
                ForEach(workoutSchedule.days, id: \.id) { workoutDay in
                    HStack {
                        Text("\(formattedDate(workoutDay.date))") // Display the date
                            .frame(width: 60, alignment: .leading)

                        Text(workoutDay.type) // Display the type of workout (Push, Pull, etc.)
                            .frame(width: 120)

                        Spacer()

                        Button(action: {
                            showWorkoutDetails(workoutDay)
                        }) {
                            Text("View Workout")
                        }
                    }
                }
            }
            .onAppear {
                workoutSchedule.generateSchedule() // Generate the workout schedule when the view appears
            }
        }
        .padding()
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd" // E.g., Dec 02
        return formatter.string(from: date)
    }

    private func showWorkoutDetails(_ workoutDay: WorkoutDay) {
        // Navigate to the detailed view of the workout
        print("Show details for \(workoutDay.type) on \(formattedDate(workoutDay.date))")
    }
}

#Preview {
    CalendarView()
}
