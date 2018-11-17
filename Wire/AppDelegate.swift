//
//  AppDelegate.swift
//  Wire
//
//  Created by Will Tyler on 11/10/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import GoogleSignIn


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

	var window: UIWindow?
	private lazy var tabBarController = TabBarController()

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		FirebaseApp.configure()

		GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
		GIDSignIn.sharedInstance().delegate = self

		window = UIWindow(frame: UIScreen.main.bounds)
		window!.rootViewController = tabBarController
		window!.makeKeyAndVisible()

		return true
	}
	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}
	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}
	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}
	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}
	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}

	// Google Sign In
	@available(iOS 9.0, *)
	func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
		return GIDSignIn.sharedInstance().handle(url, sourceApplication:options[.sourceApplication] as? String, annotation: [:])
	}
	func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
		guard error == nil else {
			print(error!)
			return
		}

		let authentication = user.authentication!
		let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)

		Auth.auth().signInAndRetrieveData(with: credential, completion: { (dataResult, error) in
			guard error == nil else {
				print(error!)
				return
			}

			self.tabBarController.dismissSignInController(animated: true)

			let dataRef = Database.database().reference()
			let usersRef = dataRef.child("users")
			let authUser = Auth.auth().currentUser!
			let userRef = usersRef.child(authUser.uid)

			userRef.updateChildValues(["email" : authUser.email!])
		})
	}
	// Called when user disconnects. Different from signing out
	func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
	}

}
