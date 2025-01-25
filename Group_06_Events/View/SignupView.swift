//
//  SignupView.swift
//  Group_06_Events
//
//  Created by Darren Eddy on 2024-03-11.
//

import SwiftUI

struct SignupView: View {
    @EnvironmentObject var firebaseAuth: FirebaseAuthHelper
    @Binding var root: RootView
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var name: String = ""
    @State private var gender: User.Gender = .male // Default gender selection
    @State private var showError = false
    @State private var errorMsg = ""
    
    var body: some View {
        VStack(spacing: 15) {
            Image("logo")
                .resizable()
                .frame(width: 150.0, height: 150.0)
            
            HStack {
                Text("Welcome to")
                    .font(.system(size: 32))
                    .fontWeight(.bold)
                
                Text("ExploreCity")
                    .font(.system(size: 32))
                    .fontWeight(.bold)
                    .foregroundColor(Color.blue)
            }
            .padding(.bottom, 40.0)
        }
        VStack {
            Form {
                Section {
                    TextField("Email", text: $email)
                    SecureField("Password", text: $password)
                }
                Section {
                    TextField("Name", text: $name)
                    Picker("Gender", selection: $gender) {
                        Text("Male").tag(User.Gender.male)
                        Text("Female").tag(User.Gender.female)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section {
                    Button {
                        Task {
                            do {
                                try await firebaseAuth.signUp(email: email, password: password, name: name, gender: gender)
                                self.root = .login
                            } catch {
                                showError = true
                                errorMsg = "Unable to Create Account"
                            }
                        }
                    } label: {
                        Spacer()
                        Text("Create")
                        Spacer()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .frame(maxHeight: 400)
            .navigationTitle("Create Admin")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        self.root = .login
                    } label: {
                        Text("Login")
                    }
                }
            }
            .alert(isPresented: $showError) {
                Alert(
                    title: Text("Error"),
                    message: Text(errorMsg),
                    dismissButton: .default(Text("Dismiss"))
                )
            }
        }// end of vstack
 
    }//ENd of body
}
