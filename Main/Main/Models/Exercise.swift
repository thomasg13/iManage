import SwiftUI

struct Exercise: Identifiable {
    let id = UUID() // Unique ID for each exercise
    var name: String
    var sets: Int
    var reps: Int
    var weight: Double? // Optional property to store weight
    var isCompleted: Bool = false // Track if the exercise is completed
}
