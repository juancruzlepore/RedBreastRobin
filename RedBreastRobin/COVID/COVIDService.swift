//
//  COVIDService.swift
//  RedBreastRobin
//
//  Created by Juan Cruz Lepore on 24/1/21.
//

import Foundation

class COVIDService: ObservableObject {
    public static let instance = COVIDService()
    
    private static let COUNTRIES = [",Argentina", ",Germany", ",United Kingdom"]
    @Published public var timeSeries: [COVIDTimeSeries] = []
    
    private init() {
        fetchCSV()
    }
    
    private func fetchCSV() {
        let timeSeriesURL = "https://api.github.com/repos/CSSEGISandData/COVID-19/contents/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv"
        HttpUtils.makeDownloadRequest(url: URL(string: timeSeriesURL)!) { (location, response, error) in
            if let location = location {
                let data = try! Data(contentsOf: location)
                if let dataContent: COVIDTimeSeriesData = try? JSONDecoder().decode(COVIDTimeSeriesData.self, from: data) {
                    let decodedData = Data(base64Encoded: dataContent.content.replacingOccurrences(of: "\n", with: ""))!
                    if let base64Decoded: String = String(data: decodedData, encoding: .utf8) {
                        let countriesSeries = base64Decoded.split(separator: "\n")
                            .filter({line in !Self.COUNTRIES.allSatisfy({country in !line.starts(with: country)})})
                            .map({line in
                                COVIDTimeSeries(country: String(line.split(separator: ",", maxSplits: 1, omittingEmptySubsequences: true).first!),
                                                timeseries: line.suffix(600).split(separator: ",").suffix(60).map({Int($0)!}))
                            })
                        DispatchQueue.main.async {
                            self.timeSeries = countriesSeries
                        }
                    }
                }
                print("COVID file fetched")
            }
        }
    }
}

struct COVIDTimeSeriesData: Decodable {
    let content: String
}

struct COVIDTimeSeries {
    let country: String
    let totalCases: [Int]
    let dailyCases: [Int]
    
    init(country: String, timeseries: [Int]) {
        self.country = country
        self.totalCases = timeseries
        (_, self.dailyCases) = totalCases.reduce((totalCases.first!, []), { (result, data) -> (Int, [Int]) in
            (data, result.1 + [data - result.0])
        })
    }
}
