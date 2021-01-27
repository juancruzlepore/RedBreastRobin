//
//  RetailAvailabilityView.swift
//  RedBreastRobin
//
//  Created by Juan Cruz Lepore on 23/1/21.
//

import SwiftUI

struct RetailAvailabilityView: View {
    @ObservedObject var ras = RetailAvailabilityService.instance
    
    var body: some View {
        VStack {
            HStack{
                Image("ps5").resizable().frame(width: 110, height: 80)
                VStack {
                    if ras.ps5ProvidersWithStock.count > 0 {
                        Text("There is stock")
                        ForEach(ras.ps5ProvidersWithStock, id: \.name) { provider in
                            Text("\(provider.name)")
                        }
                    } else {
                        Text("There is no stock")
                    }
                }.frame(width: 120)
            }
            HStack{
                Image("lgc1").resizable().frame(width: 110, height: 80)
                VStack {
                    if ras.lgc1Available == true {
                        Text("For sale")
                    } else {
                        Text("Coming soon")
                    }
                }.frame(width: 120)
            }
        }
        
    }
}

struct RetailAvailabilityView_Previews: PreviewProvider {
    static var previews: some View {
        RetailAvailabilityView()
    }
}
