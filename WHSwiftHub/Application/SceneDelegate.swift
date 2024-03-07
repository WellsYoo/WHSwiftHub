//
//  SceneDelegate.swift
//  WHSwiftHub
//
//  Created by Wells on 2024/3/7.
//

import UIKit
import Toast_Swift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        
        let libsManager = LibsManager.shared
        libsManager.setupLibs()

        if Configs.Network.useStaging == true {
            // Logout
            User.removeCurrentUser()
            AuthManager.removeToken()

            // Use Green Dark theme`
            var theme = ThemeType.currentTheme()
            if theme.isDark != true {
                theme = theme.toggled()
            }
            theme = theme.withColor(color: .green)
            themeService.switch(theme)

            // Disable banners
            libsManager.bannersEnabled.accept(false)
        } else {
            connectedToInternet().skip(1).subscribe(onNext: { [weak self] (connected) in
                var style = ToastManager.shared.style
                style.backgroundColor = connected ? UIColor.Material.green: UIColor.Material.red
                let message = connected ? R.string.localizable.toastConnectionBackMessage.key.localized(): R.string.localizable.toastConnectionLostMessage.key.localized()
                let image = connected ? R.image.icon_toast_success(): R.image.icon_toast_warning()
                if let view = self?.window?.rootViewController?.view {
                    view.makeToast(message, position: .bottom, image: image, style: style)
                }
            }).disposed(by: rx.disposeBag)
        }

        // Show initial screen
        Application.shared.presentInitialScreen(in: window!)

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
    }


}

