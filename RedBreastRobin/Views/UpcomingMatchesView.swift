//
//  UpcomingMatchesView.swift
//  RedBreastRobin
//
//  Created by Juan Cruz Lepore on 22/1/21.
//

import SwiftUI

struct UpcomingMatchesView: View {
    @ObservedObject var fs = FootballService.instance
    
    var body: some View {
        VStack {
            ForEach(fs.upcomingMatches.sorted(by: {$0.value.strTimestamp < $1.value.strTimestamp}), id: \.key) { key, match in
                HStack{
                    Text(convertDateFormat(match.strTimestamp)).frame(width: 150)
                    VStack {
                        if (fs.teamsData[match.idHomeTeam] != nil && fs.teamsData[match.idAwayTeam] != nil) {
                            HStack {
                                VStack {
                                    TeamBadgeView(teamId: match.idHomeTeam)
                                    Text("\(fs.teamsData[match.idHomeTeam]!.strTeam)")
                                }
                                Text(" vs ")
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

    private func convertDateFormat(_ dateStr: String) -> String {
        if let date = DateUtils.parseISO8601(fromString: dateStr) {
            if DateUtils.isToday(date: date) {
                return "Today, " + DateUtils.formatJustMinutes(date: date)
            } else if DateUtils.isTomorrow(date: date) {
                return "Tomorrow, " + DateUtils.formatJustMinutes(date: date)
            }
            return DateUtils.formatLongDateWithMinutes(date: date)
        }
        return "Unable to parse date"
    }
}


struct UpcomingMatchesView_Previews: PreviewProvider {
    static var previews: some View {
        UpcomingMatchesView()
    }
}
