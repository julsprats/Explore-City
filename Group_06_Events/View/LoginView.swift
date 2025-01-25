//
//  LoginView.swift
//  Group_06_Events
//
//  Created by Darren Eddy on 2024-03-11.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var firebaseAuth: FirebaseAuthHelper
    @Binding var root : RootView
    
    @AppStorage("KEY_USER") private var usernameFromUi: String = ""
    @AppStorage("KEY_PASSWORD") private var passwordFromUi:String = ""
    @AppStorage("KEY_REMEMBER") private var rememberUserAndPassword = false
    
    @State private var showError = false
    @State private var errorMessage = ""
    
    
    var body: some View {
        NavigationStack{
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
                } // HStack
                .padding(.bottom, 40.0)
            }
            VStack{
                Form{
                    Section{
                        HStack{
                            TextField("Enter Email", text: self.$usernameFromUi)
                                .autocorrectionDisabled(true)
                                .textInputAutocapitalization(.never)
                            
                            Image(systemName: "person.fill")
                        }
                        HStack{
                            SecureField("Enter Password", text: self.$passwordFromUi)
                                .autocorrectionDisabled(true)
                                .textInputAutocapitalization(.never)
                            Image(systemName: "key.horizontal.fill")
                        }
                    } header: {Text("LogIn")}
                    
                    
                    Section{
                        Toggle("Remember Me", isOn: self.$rememberUserAndPassword)
                            .toggleStyle(SwitchToggleStyle(tint: Color.blue))
                    }
                    
                    
                    Section{
                        Button{
                            if (usernameFromUi != "" && passwordFromUi != ""){
                                Task {
                                    do {
                                        try await firebaseAuth.signIn(email: usernameFromUi, password:passwordFromUi)
                                        if (!self.rememberUserAndPassword){
                                            clearLogin()
                                        }
                                    } catch
                                    {
                                        showError = true
                                        errorMessage = "Unable To Login"
                                    }
                                }
                            }
                            
                            
                        }label: {
                            HStack{
                                Spacer()
                                Text ("Log In")
                                Spacer()
                            }
                            
                        }.alert(isPresented: $showError, content: {
                            Alert(title: Text("Error"),
                                  message: Text("\(errorMessage)"),
                                  dismissButton: .default(Text("Dismiss"))
                            )
                        })
                        .buttonStyle(.borderedProminent)
                        
                        Button{
                            self.root = .signup
                        }label: {
                            HStack{
                                Spacer()
                                Text ("Create Account")
                                Spacer()
                            }
                        }
                    }
                }.frame(maxHeight: 400)
            }
        }
    }
    
    private func clearLogin()
    {
        
        self.usernameFromUi = ""
        self.passwordFromUi = ""
        self.rememberUserAndPassword = false
        
        print("User Cleared")
    }
}
