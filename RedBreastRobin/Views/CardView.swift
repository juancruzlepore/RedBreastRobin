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
        self.child.padding(.all, 8).overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray(value: 0.1), lineWidth: 2)
        )
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView {
            Text("test").frame(width: 70, height: 20, alignment: .center)
        }
    }
}
