//
//  ContentView.swift
//  RedBreastRobin
//
//  Created by Juan Cruz Lepore on 14/1/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            CardView {
                FootballView()
            }
            HStack{
                CardView { RetailAvailabilityView() }
                CardView { COVIDView() }
            }
        }.padding(.all, 30)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
