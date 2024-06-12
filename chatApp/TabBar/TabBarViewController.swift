import UIKit
import SnapKit

final class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        self.delegate = self
        self.selectedIndex = 0
        navigationItem.hidesBackButton = true
        updateTabBar(forSelectedIndex: 0)
        
        let bottomInset: CGFloat = 40
        tabBar.frame.size.height += bottomInset
        tabBar.frame.origin.y -= bottomInset
        tabBar.layer.cornerRadius = 24
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tabBar.layer.masksToBounds = true
    }
        
    // MARK: - setupTabBar
    
    private func setupNavigationBar() {
        let contactsVC = ContactsViewController()
        let chatsVC = ChatsViewController()
        let helperVC = ChatsViewController()
        let moreVC = MoreViewController()

        tabBar.tintColor = UIColor(named: "nblack")
        tabBar.unselectedItemTintColor = UIColor.white
        tabBar.backgroundColor = UIColor(named: "nwhite")
        
        self.viewControllers = [
            createNavController(for: contactsVC, image: UIImage(named: "tab1"), selectedImage: UIImage(named: "tab1s")),
            createNavController(for: chatsVC, image: UIImage(named: "tab2"), selectedImage: UIImage(named: "tab2s")),
            createNavController(for: helperVC, image: UIImage(named: "tab4"), selectedImage: UIImage(named: "tab4s")),
            createNavController(for: moreVC, image: UIImage(named: "tab3"), selectedImage: UIImage(named: "tab3s"))
        ]
    }

    private func createNavController(for rootViewController: UIViewController, image: UIImage?, selectedImage: UIImage?) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootViewController)
        
        navController.tabBarItem.image = image?.withRenderingMode(.alwaysOriginal)
        navController.tabBarItem.selectedImage = selectedImage?.withRenderingMode(.alwaysOriginal)
        return navController
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let index = tabBar.items?.firstIndex(of: item) else { return }
        updateTabBar(forSelectedIndex: index)
        animateTabBarItem(item)
    }
    
    private func updateTabBar(forSelectedIndex selectedIndex: Int) {
        guard let items = tabBar.items else { return }
        
        for (index, item) in items.enumerated() {
            let verticalInset: CGFloat = (index == selectedIndex) ? -3 : 3
            item.imageInsets = UIEdgeInsets(top: verticalInset, left: 0, bottom: -verticalInset, right: 0)
        }
    }

    private func animateTabBarItem(_ item: UITabBarItem) {
        guard let itemView = item.value(forKey: "view") as? UIView else { return }
        
        let animationDuration = 0.3
        
        // Initial state (start from below and transparent)
        itemView.transform = CGAffineTransform(translationX: 0, y: 50)
        itemView.alpha = 0.0
        
        // Animate to final state (at original position and fully opaque)
        UIView.animate(withDuration: animationDuration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            itemView.transform = .identity
            itemView.alpha = 1.0
        }, completion: nil)
    }
}
