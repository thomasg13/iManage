import SwiftUI

struct LineChartView: View {
    var data: [CGFloat] // Array of data points (weights for the exercise)
    var title: String
    var legend: String
    
    private let lineColor: Color = .blue
    private let pointColor: Color = .red
    
    var body: some View {
        VStack {
            Text(title)
                .font(.title)
                .bold()
                .padding(.top)
            
            Text(legend)
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.bottom)
            
            GeometryReader { geometry in
                let width = geometry.size.width
                let height = geometry.size.height
                let stepWidth = width / CGFloat(data.count - 1) // Calculate the width for each data point
                
                Path { path in
                    path.move(to: CGPoint(x: 0, y: height - data[0]))
                    
                    for i in 1..<data.count {
                        path.addLine(to: CGPoint(x: CGFloat(i) * stepWidth, y: height - data[i]))
                    }
                }
                .stroke(lineColor, lineWidth: 2)
                
                ForEach(0..<data.count, id: \.self) { i in
                    Circle()
                        .frame(width: 6, height: 6)
                        .foregroundColor(pointColor)
                        .position(x: CGFloat(i) * stepWidth, y: height - data[i])
                }
            }
            .frame(height: 250)
            .padding()
        }
        .padding()
    }
}
