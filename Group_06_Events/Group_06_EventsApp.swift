//
//  Group_06_EventsApp.swift
//  Group_06_Events
//
//  Created by Darren Eddy on 2024-03-11.
//

import SwiftUI

import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }

}



@main
struct Group_06_EventsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var firebaseAuth = FirebaseAuthHelper()
    @StateObject var fireDB = FireDBHelper.getInstance()
    let locationHelper = LocationHelper()

    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(firebaseAuth).environmentObject(fireDB).environmentObject(locationHelper)
        }
    }
}
