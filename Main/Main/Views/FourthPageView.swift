//
//  FourthPageView.swift
//  Main
//
//  Created by Thomas Guo on 12/2/24.
//
import SwiftUI

struct FourthPageView: View {
    @State private var waterGoal: Double = 2000
    @State private var calorieGoal: Double = 2000
    @State private var pageGoal: Double = 10
    @State private var exerciseGoal: Double = 45
    
    @State private var isEditingGoals = false;
    @State private var isLoggingData = false;
    
    @State private var waterAmount: Double = 0;
    @State private var calorieAmount: Double = 0;
    @State private var pageAmount: Double = 0;
    @State private var exerciseAmount: Double = 0;

    var body: some View {
        VStack {
            Text("Daily Goals")
                .font(.largeTitle)
                .bold()
                .padding(.top, 20)
            
            HStack {
                CircularProgressBar(progress: calculatePercentage(current: waterAmount, goal: waterGoal), lineWidth: 15, barColor: .blue, text: "Water")
                    .frame(width: 150, height: 150)
                CircularProgressBar(progress: calculatePercentage(current: calorieAmount, goal: calorieGoal), lineWidth: 15, barColor: .yellow, text: "Calories")
                    .frame(width: 150, height: 150)
            }
            HStack {
                CircularProgressBar(progress: calculatePercentage(current: pageAmount, goal: pageGoal), lineWidth: 15, barColor: .green, text: "Books")
                    .frame(width: 150, height: 150)
                CircularProgressBar(progress: calculatePercentage(current: exerciseAmount, goal: exerciseGoal), lineWidth: 15, barColor: .red, text: "Exercise")
                    .frame(width: 150, height: 150)
            }
            HStack{
                Button(action: {
                    isEditingGoals.toggle()
                }) {
                    Text("Change Goals")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                Button(action: {
                    isLoggingData.toggle()
                }) {
                    Text("Log Data")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            Spacer()
        }
        .sheet(isPresented: $isEditingGoals) {
            EditingGoalsView(
                waterGoal: $waterGoal,
                calorieGoal: $calorieGoal,
                exerciseGoal: $exerciseGoal,
                pageGoal: $pageGoal
            )
        }
        .sheet(isPresented: $isEditingGoals) {
            //log data
        }
        
    }
    
    private func calculatePercentage(current: Double, goal: Double) -> Double {
        
        guard goal > 0 else { return 0.0 }
        return min(current / goal, 1.0)
    }
}

struct CircularProgressBar: View {
    var progress: Double
    var lineWidth: CGFloat = 20
    var barColor: Color = .blue
    var backgroundColor: Color = .gray.opacity(0.2)
    var text: String = "Test"

    var body: some View {
        ZStack {
            Circle()
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .foregroundColor(backgroundColor)

            Circle()
                .trim(from: 0.0, to: progress)
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .foregroundColor(barColor)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut, value: progress)

            VStack {
                Text(text)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text("\(Int(progress * 100))%")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(barColor)
            }
        }
        .padding(lineWidth / 2)
    }
}

struct EditingGoalsView: View {
    @Binding var waterGoal: Double
    @Binding var calorieGoal: Double
    @Binding var exerciseGoal: Double
    @Binding var pageGoal: Double
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            Text("Set Your Daily Goals")
                .font(.largeTitle)
                .bold()

            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Water Consumption (mL)")
                        .font(.subheadline)
                    Spacer()
                    TextField("0", value: $waterGoal, format: .number)
                        .multilineTextAlignment(.trailing)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .frame(width: 100) // Set width for consistency
                }
                .padding(.horizontal)

                HStack {
                    Text("Food Intake (cal)")
                        .font(.subheadline)
                    Spacer()
                    TextField("0", value: $calorieGoal, format: .number)
                        .multilineTextAlignment(.trailing)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .frame(width: 100)
                }
                .padding(.horizontal)

                HStack {
                    Text("Exercise Time (min)")
                        .font(.subheadline)
                    Spacer()
                    TextField("0", value: $exerciseGoal, format: .number)
                        .multilineTextAlignment(.trailing)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .frame(width: 100)
                }
                .padding(.horizontal)

                HStack {
                    Text("Reading (pages)")
                        .font(.subheadline)
                    Spacer()
                    TextField("0", value: $pageGoal, format: .number)
                        .multilineTextAlignment(.trailing)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .frame(width: 100)
                }
                .padding(.horizontal)
            }
            .padding(.top)

            Button(action: {
                dismiss() // Save and dismiss
            }) {
                Text("Set Goals")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}




#Preview {
    FourthPageView()
}
