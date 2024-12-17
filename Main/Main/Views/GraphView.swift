//
//  GraphView.swift
//  Main
//
//  Created by Leo Ouyang on 12/2/24.
//

import SwiftUI
import Charts

// GraphView that displays weight progress for a selected exercise
struct GraphView: View {
    var exercise: Exercise // The exercise for which progress will be shown

    var body: some View {
        VStack {
            Text("\(exercise.name) Progress")
                .font(.title)
                .bold()
                .padding()

            // Map weight entries into ChartDataEntry objects
            let chartDataEntries = exercise.weights.map { entry in
                ChartDataEntry(x: entry.date.timeIntervalSince1970, y: entry.weight)
            }

            // LineChartView to display the graph
            LineChartView(data: chartDataEntries, title: "Weight Progress", legend: exercise.name)
                .padding()
                .frame(height: 300) // Set the height of the chart
        }
    }
}
