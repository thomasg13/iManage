import SwiftUI

struct WorkoutDetailView: View {
    var workoutDay: WorkoutDay

    var body: some View {
        VStack {
            Text("Workout for \(formattedDate(workoutDay.date))")
                .font(.largeTitle)
                .bold()
                .padding()

            Text(workoutDay.type)
                .font(.title2)
                .foregroundColor(.gray)

            List(workoutDay.exercises) { exercise in
                VStack(alignment: .leading) {
                    Text(exercise.name)
                        .font(.headline)
                    Text("Sets: \(exercise.sets), Reps: \(exercise.reps)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }

            Button(action: {
                markWorkoutAsComplete()
            }) {
                Text(workoutDay.isCompleted ? "Completed" : "Mark as Completed")
                    .padding()
                    .background(workoutDay.isCompleted ? Color.green : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd" // E.g., Dec 02
        return formatter.string(from: date)
    }

    private func markWorkoutAsComplete() {
        // Mark the workout as completed (could update the model here)
        print("Workout completed for \(formattedDate(workoutDay.date))")
    }
}
