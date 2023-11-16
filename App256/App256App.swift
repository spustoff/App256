//
//  App256App.swift
//  App256
//
//  Created by Вячеслав on 11/15/23.
//

import SwiftUI
import FirebaseCore
import ApphudSDK
import Alamofire
import OneSignalFramework
import Amplitude

class AppDelegate: NSObject, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Apphud.start(apiKey: "app_2YwPbia1LSw1R4AssrcZ7zTEe5GkLu")
        
        notificationsGetStarted()
        
        OneSignal.initialize("74bb9488-d97d-4711-9d3b-d71c5f7a284d", withLaunchOptions: launchOptions)
        Amplitude.instance().initializeApiKey("37760c9f3e42f3d43050dd5324986793")
        
        Amplitude.instance().defaultTracking.sessions = true
        Amplitude.instance().setUserId(Apphud.userID())
        OneSignal.login(Apphud.userID())
        
        FirebaseApp.configure()
        
        return true
    }
}

func notificationsGetStarted() {
    
    let url = "https://onesignal-ba.com/api/os/gtQSFy0DxcFyzp1KinLz/\(Apphud.userID())"
    
    let request = AF.request(url, method: .get)
    
    request.response { response in
                       
        switch response.result {
            
        case .success(_):
            
            print("ok")
            
        case .failure(_):
            
            print("failure")
        }
    }
}

@main
struct App256App: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        
        WindowGroup {
            
            NavigationView(content: {
                
                ContentView()
            })
        }
    }
}
