//
//  IOSBarChart.swift
//  iosnative
//
//  Created by Dark Matter on 11/29/23.
//

import SwiftUI
import Charts

public struct IOSBarChart: View {
    private var data: [ChartData]

    public init(data: [ChartData]) {
        self.data = data
    }

    public var body: some View {
        BarChartView(data: data)
            .padding()
    }
}

// Bar Chart Data Model
struct BarChartData: Identifiable {
    var id = UUID()
    var label: String
    var value: Double
}

// Bar Chart View
struct BarChartView: View {
    var data: [ChartData]

    var body: some View {
        VStack {
            HStack(alignment: .bottom, spacing: 10) {
                ForEach(data) { entry in
                    BarView(entry: entry)
                }
            }

            // Horizontal Axis Markers
            HStack {
                ForEach(data, id: \.id) { entry in
                    Text(entry.day)
                        .frame(width: 30)
                }
            }
        }
    }
}

// Bar View
struct BarView: View {
    var entry: ChartData

    var body: some View {
        VStack {
            Text(entry.day)
                .padding(.bottom, 5)
            Rectangle()
                .fill(Color.blue)
                .frame(width: 30, height: CGFloat(entry.count), alignment: .center)
            Text(String(format: "%.0f", entry.count))
                .padding(.top, 5)
        }
    }
}

struct IOSBarChart_Previews: PreviewProvider {
    static var previews: some View {
        IOSBarChart(data: [])
    }
}



public struct ChartData: Identifiable {
    public var id = UUID()
    public  var day: String
    public  var count: Double
    public  var secondaryCount: Double
  
    
    public init(day: String, count: Double, secondaryCount: Double, id: UUID = UUID()) {
        self.day = day
        self.count = count
        self.secondaryCount = secondaryCount
        self.id = id
    }
}



public class SwiftUIInUIView<Content: View>: UIView {
    init(content: Content) {
        super.init(frame: CGRect())
        let hostingController = UIHostingController(rootView: content)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(hostingController.view)
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension SwiftUIInUIView{
    
    public static func barChart(chartData : [ChartData]) -> any View{
        return IOSBarChart(data: chartData)
    }
}
