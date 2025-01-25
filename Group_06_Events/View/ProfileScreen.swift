//
//  ProfileScreen.swift
//  Group_06_Events
//
//  Created by Vaishnavi Selvakumar Selvakumar on 2024-03-12.
//

import SwiftUI

struct ProfileScreen: View {
    
    @EnvironmentObject var firebaseAuth: FirebaseAuthHelper
    
    @State private var firstNameFromUI: String = ""
    @State private var lastNameFromUI: String = ""
    @State private var contactNumberFromUI: Int = 0
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    if firebaseAuth.user?.gender == .male {
                        Image("male_profile")
                            .resizable()
                            .frame(width: 120.0, height: 120.0)
                    } else {
                        Image("female_profile")
                            .resizable()
                            .frame(width: 120.0, height: 120.0)
                    }
                }
                VStack(alignment: .leading, spacing: 5) {
                    Text("Name: \(firebaseAuth.user?.name ?? "")")
                    Text("Email: \(firebaseAuth.user?.email ?? "")")
                }
                Spacer()
            }
            .navigationTitle("Profile")
            .padding()
            
            Button(action: {
                firebaseAuth.logout()
            }) {
                Text("Logout")
                    .foregroundColor(.blue)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue, lineWidth: 2)
                    )
            }
            
            Spacer()
        }
        .padding(.top, 20) // Add top padding to align at the top of the page
    }
}

#Preview {
    ProfileScreen()
}
