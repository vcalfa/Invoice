//
//  SceneDelegate.swift
//  Invoice
//
//  Created by Vladimir Calfa on 18/06/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options _: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(for: windowScene, rootViewController: RootViewController.viewController())

        if let restoreUserActivity = session.stateRestorationActivity,
           let navigationController = window?.rootViewController as? UINavigationController,
           let restorableViewController = navigationController.viewControllers.first as? StateRestorable
        {
            restorableViewController.restore(with: restoreUserActivity)
        }
    }

    func sceneDidBecomeActive(_: UIScene) {
        window?.windowScene?.userActivity?.becomeCurrent()
    }

    func sceneWillResignActive(_: UIScene) {
        LocalStorage.shared.saveContext()
        window?.windowScene?.userActivity?.resignCurrent()
    }

    func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
        return scene.userActivity
    }
}

private extension UIWindow {
    convenience init(for windowScene: UIWindowScene, rootViewController: UIViewController?) {
        self.init(frame: windowScene.coordinateSpace.bounds)
        self.windowScene = windowScene
        self.rootViewController = rootViewController
        makeKeyAndVisible()
    }
}
