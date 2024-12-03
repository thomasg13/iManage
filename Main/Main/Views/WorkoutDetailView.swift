import SwiftUI

struct WorkoutDetailView: View {
    @Binding var workoutDay: WorkoutDay

    var body: some View {
        VStack(spacing: 20) {
            // Header with date and workout type in the same line
            HStack {
                Text("Workout for \(formattedDate(workoutDay.date)):")
                    .font(.title2)
                    .bold()

                Spacer()

                Text(workoutDay.type)
                    .font(.title3)
                    .bold()
                    .foregroundColor(.blue)
            }
            .padding(.top, 20)

            // Exercises List
            List($workoutDay.exercises) { $exercise in
                VStack(alignment: .leading, spacing: 10) {
                    Text(exercise.name)
                        .font(.headline)
                        .padding(.bottom, 5)

                    HStack {
                        // Weight input
                        TextField("Weight (lbs)", value: $exercise.weight, formatter: NumberFormatter())
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)
                            .frame(width: 150) // Slightly longer input box

                        Spacer()

                        // Complete Button
                        Button(action: {
                            exercise.isCompleted.toggle()
                        }) {
                            Text(exercise.isCompleted ? "Completed" : "Complete")
                                .padding(10)
                                .background(exercise.isCompleted ? Color.gray : Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding(.vertical, 5)
            }
            .listStyle(InsetGroupedListStyle())
        }
        .padding(.horizontal, 20)
        .navigationBarTitle("Workout Details", displayMode: .inline)
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd" // E.g., Dec 02
        return formatter.string(from: date)
    }
}
