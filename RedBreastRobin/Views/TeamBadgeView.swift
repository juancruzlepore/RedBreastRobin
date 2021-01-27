//
//  TeamBadgeView.swift
//  RedBreastRobin
//
//  Created by Juan Cruz Lepore on 21/1/21.
//

import SwiftUI

struct TeamBadgeView: View {
    @ObservedObject var fs = FootballService.instance
    let teamId: String
    static let SIZE: CGFloat = 70
    
    var body: some View {
        VStack {
            if fs.getBadge(forTeam: teamId) != nil {
                Image(nsImage: NSImage(data: fs.getBadge(forTeam: teamId)!)!).resizable().frame(width: Self.SIZE, height: Self.SIZE)
            } else {
                Text("Loading image...")
            }
        }
    }
}

struct TeamBadgeView_Previews: PreviewProvider {
    static var previews: some View {
        TeamBadgeView(teamId: "\(FootballService.Teams.BOCA.rawValue)")
    }
}
