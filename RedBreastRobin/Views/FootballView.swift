//
//  FootballView.swift
//  RedBreastRobin
//
//  Created by Juan Cruz Lepore on 19/1/21.
//

import SwiftUI

struct FootballView: View {
    var body: some View {
        HStack {
            PastMatchView().frame(width: 500)
            UpcomingMatchesView().frame(width: 500)
        }
        
    }
}

struct FootballView_Previews: PreviewProvider {
    static var previews: some View {
        FootballView()
    }
}
