//
//  COVIDView.swift
//  RedBreastRobin
//
//  Created by Juan Cruz Lepore on 24/1/21.
//

import SwiftUI

struct COVIDView: View {
    @ObservedObject var cs = COVIDService.instance
    
    func doubleValues(timeSeries: COVIDTimeSeries) -> [Double] {
        timeSeries.dailyCases.map({ val in Double(val) })
    }
    
    func average(array: Array<Int>.SubSequence) -> Double {
        return Double(array.reduce(0, +) / array.count)
    }
    
    func sevenDaysAverageValues(timeSeries: COVIDTimeSeries) -> [Double] {
        let windowSize: Int = 7
        return (windowSize...timeSeries.dailyCases.count)
            .map({
                average(array: timeSeries.dailyCases[$0-windowSize..<$0])
            })
    }
    
    var body: some View {
        VStack {
            ForEach(cs.timeSeries, id: \.country ) { ts in
                HStack {
                    VStack{
                        Text("\(ts.country)")
                        HStack{
                            Text("Cases yesterday: \(ts.dailyCases.last!)")
                            if ts.dailyCases.last! <= ts.dailyCases[ts.dailyCases.count - 2] {
                                Text("▼").foregroundColor(.green)
                            } else {
                                Text("▲").foregroundColor(.red)
                            }
                        }
                        HStack{
                            if let averages = sevenDaysAverageValues(timeSeries: ts) {
                                Text("7-days average: \(Int(averages.last!))")
                                if averages.last! <= averages[averages.count - 2] {
                                    Text("▼").foregroundColor(.green)
                                } else {
                                    Text("▲").foregroundColor(.red)
                                }
                            }
                        }
                    }
                    ZStack{
                        LineChartView(data: doubleValues(timeSeries: ts),
                                      color: Color.green)
                            .frame(width: 200, height: 100)
                        LineChartView(data: sevenDaysAverageValues(timeSeries: ts),
                                      color: Color.blue)
                            .frame(width: 200, height: 100)
                    }
                }
            }
        }
    }
    

}

struct COVIDView_Previews: PreviewProvider {
    static var previews: some View {
        COVIDView()
    }
}
