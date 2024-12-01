import SwiftUI

struct Exercise: Identifiable {
    let id = UUID() // Unique ID for each exercise
    var name: String
    var sets: Int
    var reps: Int
}
