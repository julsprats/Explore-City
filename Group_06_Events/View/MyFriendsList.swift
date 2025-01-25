//
//  MyFriendsList.swift
//  Group_06_Events
//
//  Created by Vaishnavi Selvakumar Selvakumar on 2024-03-12.
//


import SwiftUI
import FirebaseFirestore

struct MyFriendsList: View {
    @StateObject var firebaseAuth: FirebaseAuthHelper
        @State private var searchText = ""
        @State private var searchResults: [User] = []
        @State private var isLoading = false
        @State private var friends: [User] = []

        var body: some View {
            NavigationView {
                VStack(spacing: 0) {
                    
                   // Divider()

                    ZStack(alignment: .bottomTrailing) {
                        // Search bar
                        SearchBar(text: $searchText, placeholder: "Search for friends")
                            .padding(.trailing, 8) // Adjust padding for the search bar
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            //.frame(width: 150) // Set the width of the search bar
                            .font(.subheadline) // Adjust the font size of the search bar text

                        // Spacer to align the search bar to the bottom right corner
                        Spacer()
                    }

                    // Friends list or search results
                    if searchText.isEmpty {
                        if friends.isEmpty {
                            Text("You have no friends.")
                        } else {
                            List(friends) { friend in
                                NavigationLink(destination: UserDetailView(firebaseAuth: firebaseAuth, user: friend)) {
                                    FriendListTile(friend: friend)
                                }
                            }
                        }
                    } else {
                        if isLoading {
                            ProgressView()
                        } else {
                            if searchResults.isEmpty {
                                Text("No users found")
                            } else {
                                List(searchResults) { user in
                                    let tag = user.id == firebaseAuth.user?.id ? "You" : (friends.contains { $0.id == user.id } ? "Friends" : "")
                                    NavigationLink(destination: UserDetailView(firebaseAuth: firebaseAuth, user: user)) {
                                        HStack {
                                            Text(user.name)
                                            if !tag.isEmpty {
                                                Text("(\(tag))")
                                                    .foregroundColor(.gray)
                                                    .font(.caption)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .navigationTitle("My Friends")
                .padding()
                .onChange(of: searchText) { newValue in
                    fetchSearchResults()
                }
                .onAppear {
                    fetchCurrentUser()
                    fetchFriends()
                }
            }
        }

        private func fetchCurrentUser() {
            Task {
                await firebaseAuth.fetchUser()
            }
        }

        private func fetchFriends() {
            Task {
                await firebaseAuth.fetchFriends()
                friends = firebaseAuth.user?.friends ?? []
            }
        }

        private func fetchSearchResults() {
            if searchText.isEmpty {
                searchResults = []
                return
            }

            isLoading = true
            Task {
                do {
                    searchResults = try await firebaseAuth.searchUsers(query: searchText)
                } catch {
                    print("Error searching users: \(error)")
                }
                isLoading = false
            }
        }
    }

    struct SearchBar: View {
        @Binding var text: String
        var placeholder: String

        var body: some View {
            TextField(placeholder, text: $text)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .disableAutocorrection(true)
        }
}

struct MyFriendsList_Previews: PreviewProvider {
    static var previews: some View {
        // Create an instance of FirebaseAuthHelper
        let firebaseAuth = FirebaseAuthHelper()
        
        // Pass the FirebaseAuthHelper instance to MyFriendsList preview
        MyFriendsList(firebaseAuth: firebaseAuth)
    }
}
