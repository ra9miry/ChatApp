import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        
        if let _ = NetworkManager.shared.getUsernameFromDefaults() {
            window?.rootViewController = UINavigationController(rootViewController: TabBarViewController())
        } else {
            window?.rootViewController = UINavigationController(rootViewController: StartViewController())
        }
        
        window?.makeKeyAndVisible()
    }
}
