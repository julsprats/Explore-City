//
//  EventList.swift
//  Group_06_Events
//
//  Created by Vaishnavi Selvakumar Selvakumar on 2024-03-12.
//

import SwiftUI

struct EventList: View {
    @EnvironmentObject var firebaseAuth: FirebaseAuthHelper
    @EnvironmentObject var fireDB : FireDBHelper
    @State var showMap = false

    var body: some View {
        Text("Event List!")
                   .font(.title)
                   .foregroundColor(.blue)
                   .padding()
                   .background(Color.gray)
                   .cornerRadius(10)
        

    }
    
}

#Preview {
    EventList()
}
