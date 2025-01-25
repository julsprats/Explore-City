//
//  ContentView.swift
//  Group_06_Events
//
//  Created by Julia Prats on 2024-03-13.
//

import Foundation
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var firebaseAuth : FirebaseAuthHelper
    @EnvironmentObject var fireDB : FireDBHelper
    @EnvironmentObject var locationHelper : LocationHelper
    
    @State var root: RootView = .login
    
    var body: some View {
        Group{
            NavigationStack{
                if firebaseAuth.user != nil {
                            // If user is authenticated, show TabView with all tabs
                            TabView {
                                NavigationView {
                                    LoggedInView().environmentObject(firebaseAuth).environmentObject(locationHelper)
                                }
                                .tabItem {
                                    Text("Home")
                                    Image(systemName: "house.fill")
                                }
                                
//                                NavigationView {
//                                    EventList().environmentObject(firebaseAuth)
//                                }
//                                .tabItem {
//                                    Text("Event List")
//                                    Image(systemName: "magnifyingglass")
//                                }
                                
                                NavigationView {
                                    MyEventList().environmentObject(firebaseAuth)
                                }
                                .tabItem {
                                    Text("My Events")
                                    Image(systemName: "calendar")
                                }
                                
                                NavigationView {
                                    MyFriendsList(firebaseAuth: firebaseAuth).environmentObject(firebaseAuth)
                                }
                                .tabItem {
                                    Text("My Friends")
                                    Image(systemName: "person.2")
                                }
                                
                                NavigationView {
                                    ProfileScreen().environmentObject(firebaseAuth)
                                }
                                .tabItem {
                                    Text("Profile")
                                    Image(systemName: "person.fill")
                                }
                            }
                        }else {
                            // If user is not authenticated, show LoginView or SignupView
                            NavigationStack {
                                switch(root) {
                                    case .login:
                                        LoginView(root: self.$root).environmentObject(firebaseAuth)
                                    case .signup:
                                        SignupView(root: self.$root).environmentObject(firebaseAuth)
                                }
                            }
                        }
                   
//
//                        CreateAdminView(root: self.$root).environmentObject(firebaseAuth)
//
                
            }//NavStack
        }//Group

    }//Bodu
}
