//
//  AppBlogDATNApp.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 21/4/25.
//

import SwiftUI
import FirebaseCore
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct AppBlogDATNApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State var appCoordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appCoordinator)
        }
    }
}
