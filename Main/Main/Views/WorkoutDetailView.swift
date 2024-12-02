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
                    HStack {
                        TextField("Weight (lbs)", text: .constant(""))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)
                            .frame(width: 100)

                        Spacer()

                        Button(action: {
                            // Mark exercise as complete logic
                            print("Completed \(exercise.name)")
                        }) {
                            Text("Complete")
                                .padding(8)
                                .background(Color.blue)
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

    // Helper to format the date
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd" // E.g., Dec 02
        return formatter.string(from: date)
    }
}
