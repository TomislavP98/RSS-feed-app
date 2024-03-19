import UIKit

class TabViewController: UITabBarController {
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
        setupVCs()
    }
    
    func setupVCs() {
        viewControllers = [
            createNavController(for: FeedsListViewController(screenType: .allFeedsScreen), title: Strings.Localization.allFeeds, image: UIImage(systemName: "chart.bar.doc.horizontal")!),
            createNavController(for: FeedsListViewController(screenType: .favoriteFeedsScreen), title: Strings.Localization.likedFeeds, image: UIImage(systemName: "heart")!)
        ]
    }
    
    fileprivate func createNavController(for rootViewController: UIViewController,
                                         title: String,
                                         image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.title = title
        return navController
    }
}
