import SwiftUI

struct WorkoutDetailView: View {
    @Binding var workoutDay: WorkoutDay

    var body: some View {
        VStack {
            Text("Workout for \(formattedDate(workoutDay.date))")
                .font(.largeTitle)
                .bold()
                .padding()

            Text(workoutDay.type)
                .font(.title2)
                .foregroundColor(.gray)

            List($workoutDay.exercises) { $exercise in
                VStack(alignment: .leading) {
                    Text(exercise.name)
                        .font(.headline)

                    HStack {
                        TextField("Weight (lbs)", value: $exercise.weight, formatter: NumberFormatter())
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)
                            .frame(width: 100)

                        Spacer()

                        Button(action: {
                            exercise.isCompleted.toggle()
                        }) {
                            Text(exercise.isCompleted ? "Completed" : "Complete")
                                .padding(8)
                                .background(exercise.isCompleted ? Color.gray : Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(.vertical, 5)
            }
        }
        .padding()
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd" // E.g., Dec 02
        return formatter.string(from: date)
    }
}
