import SwiftUI

struct WorkoutSchedule {
    var days: [WorkoutDay] // Array of all workout days

    init() {
        self.days = []
    }

    mutating func generateSchedule() {
        let workoutTypes = ["Push", "Pull", "Legs", "Rest"] // 4 workout types
        let exercisesForPush: [Exercise] = [
            Exercise(name: "Bench Press", sets: 3, reps: 8),
            Exercise(name: "Chest Fly", sets: 3, reps: 12)
        ]
        let exercisesForPull: [Exercise] = [
            Exercise(name: "Pull Ups", sets: 3, reps: 8),
            Exercise(name: "Bent Over Rows", sets: 3, reps: 12)
        ]
        let exercisesForLegs: [Exercise] = [
            Exercise(name: "Squats", sets: 4, reps: 10),
            Exercise(name: "Lunges", sets: 3, reps: 12)
        ]

        var currentDate = Date() // Starting date for the schedule

        for i in 0..<30 { // Assume we are generating a 30-day schedule
            let workoutType = workoutTypes[i % 4] // Correct the modulo operation to 4

            var exercises: [Exercise] = []

            switch workoutType {
            case "Push":
                exercises = exercisesForPush
            case "Pull":
                exercises = exercisesForPull
            case "Legs":
                exercises = exercisesForLegs
            default:
                break
            }

            let workoutDay = WorkoutDay(date: currentDate, type: workoutType, exercises: exercises)
            self.days.append(workoutDay)

            // Increment the date by 1 day
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }
    }
}
