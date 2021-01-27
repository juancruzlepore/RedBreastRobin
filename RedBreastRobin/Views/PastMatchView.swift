//
//  PastMatchView.swift
//  RedBreastRobin
//
//  Created by Juan Cruz Lepore on 19/1/21.
//

import SwiftUI

struct PastMatchView: View {
    @ObservedObject var fs = FootballService.instance
    
    var body: some View {
        VStack {
            ForEach(fs.lastMatches.sorted(by: {$0.value.dateEvent > $1.value.dateEvent}), id: \.key) { key, match in
                HStack{
                    Text(formatDate(match.strTimestamp)).frame(width: 150)
                    VStack {
                        if (fs.teamsData[match.idHomeTeam] != nil && fs.teamsData[match.idAwayTeam] != nil) {
                            HStack {
                                VStack {
                                    TeamBadgeView(teamId: match.idHomeTeam)
                                    Text("\(fs.teamsData[match.idHomeTeam]!.strTeam)")
                                }
                                Text(" \(match.intHomeScore) - \(match.intAwayScore) ")
                                VStack {
                                    TeamBadgeView(teamId: match.idAwayTeam)
                                    Text("\(fs.teamsData[match.idAwayTeam]!.strTeam)")
                                }
                            }
                        } else {
                            Text("Loading match...")
                        }
                    }
                }
            }
        }
    }
    
    private func formatDate(_ strDate: String) -> String {
        if let date = DateUtils.parseISO8601(fromString: strDate) {
            if DateUtils.isToday(date: date) {
                return "Today"
            } else if DateUtils.isYesterday(date: date) {
                return "Yesterday"
            }
            let df = DateFormatter()
            df.dateFormat = "E DD MMM"
            return df.string(from: date)
        }
        return "Unable to parse date"
    }
}

struct PastMatchView_Previews: PreviewProvider {
    static var previews: some View {
        PastMatchView()
    }
}
