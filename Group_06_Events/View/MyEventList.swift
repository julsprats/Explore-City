//
//  MyEventList.swift
//  Group_06_Events
//
//  Created by Julia Prats on 2024-03-13.
//

import Foundation
import SwiftUI

struct MyEventList: View {
    @EnvironmentObject var firebaseAuth: FirebaseAuthHelper
    @EnvironmentObject var fireDB : FireDBHelper
    @State var showMap = false
    @State var userEvents: [Event] = []

    var body: some View {
        NavigationStack {
            VStack (alignment: .leading, spacing: 0) {
                
                if userEvents.isEmpty {
                    Text("No events in your list.")
                        .foregroundColor(.gray)
                } else {
                    List(userEvents, id: \.id) { event in
                        NavigationLink(destination: EventDetailsView(event: event)) {
                            ActivityListTile(event: event)
                        }
                    }
                }
            }
            .navigationTitle("My Events")
            .padding(.top, 0)
            .onAppear {
                fetchUserEvents()
            }
        }
    }
    
    func fetchUserEvents() {
        firebaseAuth.fetchFavsUser { favorites in
            userEvents = favorites
        }
    }
}

struct MyEventList_Previews: PreviewProvider {
    static var previews: some View {
        MyEventList()
    }
}

