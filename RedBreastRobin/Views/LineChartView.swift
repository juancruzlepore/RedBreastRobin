//
//  LineChartView.swift
//  RedBreastRobin
//
//  Created by Juan Cruz Lepore on 25/1/21.
//

import SwiftUI

struct LineChartView: View {
    
    var data: [Double]
    var color: Color
    
    var body: some View {
        GeometryReader{ reader in
            Line(data: self.data,
                 color: self.color,
                 frame: .constant(CGRect(x: 0, y: 0, width: reader.frame(in: .local).width , height: reader.frame(in: .local).height)))
        }
    }
}

struct Line: View {
    var data: [(Double)]
    var color: Color
    @Binding var frame: CGRect

    let padding:CGFloat = 30
    
    var stepWidth: CGFloat {
        if data.count < 2 {
            return 0
        }
        return frame.size.width / CGFloat(data.count-1)
    }
    var stepHeight: CGFloat {
        let points = self.data
        if let min = points.min(), let max = points.max(), min != max {
            if (min <= 0) {
                return (frame.size.height-padding) / CGFloat(max - min)
            } else {
                return (frame.size.height-padding) / CGFloat(max + min)
            }
        }
        return 0
    }
    
    var path: Path {
        let points = self.data
//        guard let offset = points.min() else { return Path() }
        return Path.lineChart(points: points,
                              step: CGPoint(x: stepWidth, y: stepHeight),
                              offset: 0)
    }
    
    public var body: some View {
        
        ZStack {

            self.path
                .stroke(self.color ,style: StrokeStyle(lineWidth: 3, lineJoin: .round))
                .rotationEffect(.degrees(180), anchor: .center)
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                .drawingGroup()
        }
    }
}

extension Path {
    
    static func lineChart(points:[Double], step:CGPoint, offset: Double) -> Path {
        var path = Path()
        if (points.count < 2){
            return path
        }
        let p1 = CGPoint(x: 0, y: CGFloat(points[0]-offset)*step.y)
        path.move(to: p1)
        for pointIndex in 1..<points.count {
            let p2 = CGPoint(x: step.x * CGFloat(pointIndex), y: step.y*CGFloat(points[pointIndex]-offset))
            path.addLine(to: p2)
        }
        return path
    }
}

struct LineChartView_Previews: PreviewProvider {
    static var previews: some View {
        LineChartView(data: [2.3, 2.6, 2.8, 2.9, 3.6], color: Color.blue)
    }
}
