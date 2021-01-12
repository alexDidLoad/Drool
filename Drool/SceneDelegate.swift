//
//  SceneDelegate.swift
//  Drool
//
//  Created by Alexander Ha on 1/9/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = createTabbar()
        window?.makeKeyAndVisible()
    }
    
    func createHomeNC() -> UINavigationController {
        let homeVC = HomeVC()
        homeVC.title = "Drool"
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        return UINavigationController(rootViewController: homeVC)
    }
    
    func createFavoritesNC() -> UINavigationController {
        let favoritesVC = FavoritesVC()
        favoritesVC.title = "Favorites"
        favoritesVC.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "heart.fill"), tag: 1)
//        favoritesVC.tabBarItem.selectedImage = favoritesVC.tabBarItem.selectedImage?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        return UINavigationController(rootViewController: favoritesVC)
    }
    
    func createTabbar() -> UITabBarController {
        let appearance = UITabBarItem.appearance()
        let tabAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.white]
        appearance.setTitleTextAttributes(tabAttributes, for: .normal)
        let navAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24), NSAttributedString.Key.foregroundColor : UIColor.white]
        
        let homeNC = createHomeNC()
        homeNC.navigationBar.barTintColor = .black
        homeNC.navigationBar.barStyle = .black
        homeNC.navigationBar.prefersLargeTitles = true
        homeNC.navigationBar.titleTextAttributes = navAttributes
        
        let favoritesNC = createFavoritesNC()
        favoritesNC.navigationBar.barTintColor = .black
        favoritesNC.navigationBar.barStyle = .black
        favoritesNC.navigationBar.titleTextAttributes = navAttributes
        
        let tabBarController = UITabBarController()
        UITabBar.appearance().tintColor = .systemRed
        tabBarController.tabBar.barTintColor = .black
        tabBarController.viewControllers = [homeNC, favoritesNC]
        let tabBarheight = tabBarController.tabBar.frame.height
        let tabBarWidth = (tabBarController.tabBar.frame.width/CGFloat(tabBarController.tabBar.items!.count) - 40)
        tabBarController.tabBar.selectionIndicatorImage = UIImage().createSelectionIndicator(color: .systemRed, size: CGSize(width: tabBarWidth, height: tabBarheight), lineWidth: 3.0)
        return tabBarController
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

