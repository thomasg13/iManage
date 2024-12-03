//
//  ExerciseProgressChart.swift
//  Main
//
//  Created by Leo Ouyang on 12/3/24.
//


import SwiftUI
import Charts

struct ExerciseProgressChart: View {
    let data: [ExerciseData]

    var body: some View {
        Chart {
            ForEach(data) { entry in
                LineMark(
                    x: .value("Date", entry.date),
                    y: .value("Weight", entry.weight)
                )
                .foregroundStyle(Color.blue)
                .lineStyle(StrokeStyle(lineWidth: 2))
            }
        }
        .chartYAxisLabel("Weight (lbs)")
        .chartXAxis {
            AxisMarks(values: .stride(by: .day, count: 5)) { value in
                AxisValueLabel(format: .dateTime.month(.abbreviated).day(.defaultDigits))
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(12)
        .shadow(radius: 5)
    }
}
