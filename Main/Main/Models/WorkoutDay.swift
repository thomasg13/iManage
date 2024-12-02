import SwiftUI

struct WorkoutDay: Identifiable {
    let id = UUID() // Unique ID for each workout day
    var date: Date // The actual date of the workout
    var type: String // "Push", "Pull", "Legs", "Rest"
    var exercises: [Exercise] // List of exercises for the day
    var isCompleted: Bool = false // Track if the workout is completed
}
