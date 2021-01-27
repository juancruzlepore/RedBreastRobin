//
//  CardView.swift
//  RedBreastRobin
//
//  Created by Juan Cruz Lepore on 26/1/21.
//

import SwiftUI

struct CardView<Content: View>: View {
    
    var child: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.child = content()
    }
    
    var body: some View {
        self.child
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView {
            Text("test")
        }
    }
}
