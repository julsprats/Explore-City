//
//  UserDetailView.swift
//  Group_06_Events
//
//  Created by Vaishnavi Selvakumar Selvakumar on 2024-03-13.
//

import SwiftUI

struct UserDetailView: View {
    var firebaseAuth: FirebaseAuthHelper
    var user: User // Use user directly instead of selectedUser
    
    @State private var attendingEvents: [Event] = []
    @State private var mutualFriends: [User] = []
    @State private var isFriend: Bool = false // State variable for friend status
    
    private let flexibleColumn = [
        
        GridItem(.fixed(100)),
          GridItem(.fixed(100)),
          GridItem(.fixed(100))
    ]
    
    var body: some View {
        VStack {
            HStack {
                if user.gender == .female {
                    Image("female_profile")
                        .resizable()
                        .frame(width: 210.0, height: 210.0)
                        .padding(.leading, 0)
                } else {
                    Image("male_profile")
                        .resizable()
                        .frame(width: 200.0, height: 200.0)
                        .padding(.leading, 0)
                }
                
                VStack(alignment: .leading) {
                    Text("Name: \(user.name)")
                    Text("Gender: \(user.gender.rawValue)")
                    Text("Number of Events Attending: \(attendingEvents.count)")
                    Button(action: {
                        if isFriend {
                            // Remove friend
                            Task {
                                do {
                                    try await firebaseAuth.removeFriend(userToRemove: user)
                                    isFriend = false // Update state
                                } catch {
                                    print("Error removing friend: \(error)")
                                }
                            }
                        } else {
                            // Add friend
                            Task {
                                do {
                                    try await firebaseAuth.addFriend(userToAdd: user)
                                    isFriend = true // Update state
                                } catch {
                                    print("Error adding friend: \(error)")
                                }
                            }
                        }
                    }) {
                        Text(isFriend ? "Remove Friend" : "Add Friend") // Button title changes based on friend status
                            .foregroundColor(user.id == firebaseAuth.user?.id ? .gray : .blue) // Change text color to grey if the button is disabled
                    }
                    .disabled(user.id == firebaseAuth.user?.id) // Disable button if the selected user is the current user

                    .padding()
                    .foregroundColor(.blue)
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue, lineWidth: 2)
                    )
                    
                    

                }
                
            }
            .padding()
            .onAppear {   
                // Fetch events the user is attending
                           attendingEvents = fetchAttendingEvents(for: user)
                           
                           // Fetch mutual friends attending the same event
                           mutualFriends = fetchMutualFriends(for: user)
                  // Check if the user is already a friend
                  isFriend = firebaseAuth.user?.friends.contains(where: { $0.id == user.id }) ?? false
              }
            
            //Next Event
            
            if let nextEvent = attendingEvents.first {
                VStack(alignment: .leading) {
                    Text("Next Event:").padding(.horizontal)
               
                            NavigationLink {
                                EventDetailsView(event: nextEvent)
                            } label: {
                                HStack{
                                    Spacer()
                                    Text("\(nextEvent.title)")
                                    Spacer()
                                }
                            }
                        
                    }
                             
                
            }

            
            //Mutual Friend Grid
            if !mutualFriends.isEmpty {
                // Display mutual friends attending the same event
                VStack(alignment: .leading) {
                    Text("Mutual Friends Attending:").padding()
                    
                    LazyVGrid(columns: flexibleColumn, spacing: 20) {
                        ForEach(mutualFriends.filter { $0.id != firebaseAuth.user?.id }, id: \.id) { friend in
                            NavigationLink {
                                UserDetailView(firebaseAuth: firebaseAuth, user: friend)
                            } label: {
                                VStack{
                                    if friend.gender == .male {
                                        Image("male_profile").resizable()
                                            .frame(width: 32.0, height: 32.0)
                                    } else {
                                        Image("female_profile").resizable()
                                            .frame(width: 32.0, height: 32.0)
                                    }
                                    Text(friend.name)
                                }
                            }
                        }
                    }.padding(.horizontal)
                }
            }

            Spacer()

        }
        .navigationBarTitleDisplayMode(.inline) // Display title inline
        .padding(.top, 20) // Add top padding
    }
    
    
    // Function to fetch events the user is attending
    private func fetchAttendingEvents(for user: User) -> [Event] {
        var attendingEvents: [Event] = []
        
        // Iterate through the user's favorites
        for favoriteEvent in user.favourites {
            // Check if the event's datetime is in the future (optional)
            // You may need to implement a function to check if the event is in the future
            // For simplicity, I'm assuming all events are in the future
            if isEventInFuture(favoriteEvent.datetime_utc) {
            
            // Add the event to the list of attending events
            attendingEvents.append(favoriteEvent)
            }
        }
        
        return attendingEvents
    }

    // Function to check if an event's datetime is in the future
    private func isEventInFuture(_ datetime: String) -> Bool {
        // Get the current date and time
        let currentDate = Date()
        
        // Create a date formatter to parse the event's datetime string
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        // Parse the event's datetime string into a Date object
        guard let eventDate = dateFormatter.date(from: datetime) else {
            // Return false if the datetime string cannot be parsed
            return false
        }
        
        // Compare the event's date with the current date
        return eventDate > currentDate
    }

    
    // Function to fetch mutual friends attending the same event
    private func fetchMutualFriends(for user: User) -> [User] {
        var mutualFriends: [User] = []
        
        // Iterate through the user's friends
        for friend in user.friends {
            // Iterate through the friend's favorites
            for friendEvent in friend.favourites {
                // Check if the event is also in the user's favorites
                if user.favourites.contains(where: { $0.id == friendEvent.id }) {
                    // Add the friend to the list of mutual friends
                    mutualFriends.append(friend)
                    // Break the inner loop to avoid duplicate mutual friends
                    break
                }
            }
        }
        
        return mutualFriends
    }

}

