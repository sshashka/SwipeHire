//
//  AppDelegate.swift
//  QuitMate
//
//  Created by Саша Василенко on 13.02.2023.
//

import UIKit
import SwiftUI
import FirebaseCore
import FirebaseDatabase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = false

//        let deleteLater = UIHostingController(rootView: SwipesView(viewModel: SwipesViewModel(jobCategory: .Java, storageService: FirebaseStorageService())))
        window = UIWindow()
        
        let navVC = UINavigationController()
//        window?.rootViewController = deleteLater
        window?.rootViewController = navVC
        
        
        
        appCoordinator = AppCoordinator(navVC)
        appCoordinator?.start()
        
        window?.makeKeyAndVisible()
        window?.backgroundColor = .systemBackground
//        registerForPushNotifications()
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        UserDefaults.standard.set(nil, forKey: "UserID")
        ApiKeysService.shared.removeKeys()
    }
    
//    func registerForPushNotifications() {
//        UNUserNotificationCenter.current()
//            .requestAuthorization(
//                options: [.alert, .sound, .badge]) { [weak self] granted, _ in
//                    print("Permission granted: \(granted)")
//                    guard granted else { return }
//                    self?.getNotificationSettings()
//                }
//    }
//
//    func getNotificationSettings() {
//        UNUserNotificationCenter.current().getNotificationSettings { settings in
//            guard settings.authorizationStatus == .authorized else { return }
//            DispatchQueue.main.async {
//                UIApplication.shared.registerForRemoteNotifications()
//            }
//            print("Notification settings: \(settings)")
//        }
//    }
    
//    func application(
//        _ application: UIApplication,
//        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
//    ) {
//        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
//        let token = tokenParts.joined()
//        print("Device Token: \(token)")
//    }
//
//    func application(
//        _ application: UIApplication,
//        didFailToRegisterForRemoteNotificationsWithError error: Error
//    ) {
//        print("Failed to register: \(error)")
//    }
    
}


//func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
//        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
//        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
//
//        // Create the SwiftUI view that provides the window contents.
//        let contentView = loginVC()
//        let env = mainClass()
//
//        // Use a UIHostingController as window root view controller.
//        if let windowScene = scene as? UIWindowScene {
//            let window = UIWindow(windowScene: windowScene)
//            window.rootViewController = UIHostingController(rootView: contentView.environmentObject(env))
//            self.window = window
//            window.makeKeyAndVisible()
//        }
//    }
