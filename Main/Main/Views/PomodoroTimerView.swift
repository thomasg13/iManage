import SwiftUI

struct PomodoroTimerView: View {
    @State private var currentTimerType: TimerType = .work
    @State private var timeRemaining: Int = TimerType.work.duration // Start with 45:00
    @State private var isRunning: Bool = false
    @State private var timer: Timer? = nil

    var body: some View {
        VStack(spacing: 20) {
            Text("Pomodoro")
                .font(.largeTitle)
                .bold()
                .padding()

            // Display current mode (Work / Short Break / Long Break)
            Text(currentTimerType.title)
                .font(.title)
                .foregroundColor(currentTimerType.color)
                .padding()

            // Timer Display
            Text(formatTime(timeRemaining))
                .font(.system(size: 60))
                .bold()

            // Timer Options (Switch between timers)
            VStack(spacing: 10) {
                Button(action: {
                    switchToTimer(.work)
                }) {
                    Text("Time to work ✍️")
                        .foregroundColor(currentTimerType == .work ? .blue : .gray)
                        .font(.title2)
                }

                Button(action: {
                    switchToTimer(.shortBreak)
                }) {
                    Text("Take a short break 🍎")
                        .foregroundColor(currentTimerType == .shortBreak ? .green : .gray)
                        .font(.title2)
                }

                Button(action: {
                    switchToTimer(.longBreak)
                }) {
                    Text("Take a long break 🥦")
                        .foregroundColor(currentTimerType == .longBreak ? .orange : .gray)
                        .font(.title2)
                }
            }

            // Timer Controls (Start/Stop / Restart)
            HStack(spacing: 30) {
                Button(action: {
                    restartTimer()
                }) {
                    Text("Restart Timer")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .clipShape(Capsule())
                }

                Button(action: {
                    if isRunning {
                        stopTimer()  // This will stop the timer
                    } else {
                        startTimer()  // This will start the timer
                    }
                }) {
                    Text(isRunning ? "Stop Timer" : "Start Timer")
                        .foregroundColor(.white)
                        .padding()
                        .background(isRunning ? Color.red : Color.green)
                        .clipShape(Capsule())
                }
            }
        }
        .padding()
        .onDisappear {
            timer?.invalidate() // Clean up the timer when the view disappears
        }
    }

    // MARK: - Helper Methods

    private func startTimer() {
        if timeRemaining == 0 {
            // Reset the timer when it hits 0
            timeRemaining = currentTimerType.duration
        }

        isRunning = true

        // Ensure only one timer instance
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                stopTimer() // Stop automatically when timer reaches 0
            }
        }
    }

    private func stopTimer() {
        isRunning = false
        timer?.invalidate()
    }

    private func restartTimer() {
        // Reset to the original duration for the current timer type
        timeRemaining = currentTimerType.duration
        startTimer() // Restart the timer
    }

    private func switchToTimer(_ type: TimerType) {
        stopTimer()
        currentTimerType = type
        timeRemaining = type.duration
    }

    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// MARK: - Timer Types

enum TimerType {
    case work
    case shortBreak
    case longBreak

    var title: String {
        switch self {
        case .work:
            return "Time to work ✍️"
        case .shortBreak:
            return "Take a short break 🍎"
        case .longBreak:
            return "Take a long break 🥦"
        }
    }

    var color: Color {
        switch self {
        case .work:
            return .blue
        case .shortBreak:
            return .green
        case .longBreak:
            return .orange
        }
    }

    var duration: Int {
        switch self {
        case .work:
            return 45 * 60 // 45 minutes
        case .shortBreak:
            return 5 * 60 // 5 minutes
        case .longBreak:
            return 15 * 60 // 15 minutes
        }
    }
}
