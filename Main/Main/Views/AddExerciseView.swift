import SwiftUI

struct AddExerciseView: View {
    @Binding var workoutDay: WorkoutDay // Pass in the specific workout day to modify
    @State private var exerciseName = ""
    @State private var sets: String = ""
    @State private var reps: String = ""

    var body: some View {
        VStack {
            Text("Add Exercise")
                .font(.largeTitle)
                .bold()

            TextField("Exercise Name", text: $exerciseName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Sets", text: $sets)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Reps", text: $reps)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                addExerciseToWorkoutDay()
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

    private func addExerciseToWorkoutDay() {
        // Validate input and create an Exercise object
        if let setCount = Int(sets), let repCount = Int(reps), !exerciseName.isEmpty {
            let newExercise = Exercise(name: exerciseName, sets: setCount, reps: repCount)
            workoutDay.exercises.append(newExercise)
            print("Exercise added: \(exerciseName), \(sets) sets, \(reps) reps")
        }
    }
}

#Preview {
    AddExerciseView(workoutDay: .constant(WorkoutDay(date: Date(), type: "Push", exercises: [], isCompleted: false)))
}
