// SceneDelegate.swift

import GoogleMaps
import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    private var appCoordinator: AppCoordinator?
    private lazy var database = Database.shared
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo _: UISceneSession,
        options _: UIScene.ConnectionOptions
    ) {
        // GMSServices.provideAPIKey("AIzaSyCee_Vw0g4kwdd5Sch1SxYoNivgk2s-TK0")
        GMSServices.provideAPIKey("AlzaSyBJboKyYBcB3sikBJJ7fRN1900dVMx4TuQ")

        configureWindow(scene: scene)
    }

    func sceneWillResignActive(_: UIScene) {
        database.saveToUserDefaults()
    }

    func scene(_: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        var url: URL?
        for urlContext in URLContexts {
            url = urlContext.url
        }
        guard let url = url else { return }
        guard let componets = NSURLComponents(url: url, resolvingAgainstBaseURL: true), let host = componets.host else {
            return
        }
        guard let deepLink = DeepLink(rawValue: host) else {
            return
        }
        let title = componets.queryItems?.first?.value ?? ""

        appCoordinator?.selectetedView(deepLink: deepLink, title: title)
    }

    private func configureWindow(scene: UIScene) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .systemBackground
        appCoordinator = AppCoordinator()
        appCoordinator?.start()
    }
}
