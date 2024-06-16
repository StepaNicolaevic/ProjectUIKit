// AppCoordinator.swift

import UIKit

/// Root application coordinator
final class AppCoordinator: BaseCoodinator {
    // MARK: - Constants

    private enum Constants {
        static let tabBarName = "MainTabBar"
        static let categoriesScreenName = "Categories"
        static let recipesScreenName = "Recipes"
        static let detailedScreenName = "Recipe detailed"
        static let profileScreenName = "Profile"
        static let authScreenName = "Authorization"
    }

    // MARK: - Private Properties

    private var mainTabBarViewController: MainTabBarViewController?
    private var builder = Builder()

    // MARK: - Public Methods

    override func start() {
        if "login" == "login" {
            showMainTabBar()

        } else {
            showAuthScreen()
        }
    }

    // MARK: - Private Methods

    private func showMainTabBar() {
        // Set Recipes
        let recipeCoordinator = RecipesCoordinator()
        let recipeModuleView = builder.makeRecipesModule(coordinator: recipeCoordinator)
        recipeCoordinator.setRootController(recipeModuleView)
        add(coordinator: recipeCoordinator)

        // Set Favorites
        let favoritesCoordinator = FavoritesCoordinator()
        let favoritesModelView = builder.makeFavoritesModule(coordinator: favoritesCoordinator)
        favoritesCoordinator.setRootController(favoritesModelView)
        add(coordinator: favoritesCoordinator)

        // Set Profile
        let profileCoordinator = ProfileCoordinator()
        let profileModelView = builder.makeProfileModule(coordinator: profileCoordinator)
        profileCoordinator.setRootController(profileModelView)
        profileCoordinator.finishFlowHandler = { [weak self] in
            self?.remove(coordinator: profileCoordinator)
            self?.showAuthScreen()
        }
        add(coordinator: profileCoordinator)

        // Set TabBarViewController
        mainTabBarViewController = MainTabBarViewController()
        mainTabBarViewController?.setViewControllers(
            [
                recipeCoordinator.publicRootController,
                favoritesCoordinator.publicRootController,
                profileCoordinator.publicRootController,
            ],
            animated: false
        )
        setAsRoot(mainTabBarViewController ?? UIViewController())
        log(.openScreen(screenName: Constants.categoriesScreenName))
    }

    private func showAuthScreen() {
        let authCoordinator = AuthCoordinator()
        let authModuleView = builder.makeAuthModule(coordinator: authCoordinator)
        authCoordinator.setRootController(authModuleView)
        authCoordinator.finishFlowHandler = { [weak self] in
            self?.remove(coordinator: authCoordinator)
            self?.showMainTabBar()
        }
        add(coordinator: authCoordinator)
        authCoordinator.start()
        log(.openScreen(screenName: Constants.authScreenName))
    }

    func selectetedView(deepLink: DeepLink, title: String) {
        switch deepLink {
        case .favorites:
            mainTabBarViewController?.selectedIndex = 1
        case .profile:
            mainTabBarViewController?.selectedIndex = 2
            if let navContr = mainTabBarViewController?.children[2] as? UINavigationController {
                if let prof = navContr.viewControllers.first as? ProfileView {
                    prof.openBunusView()
                    prof.showLogOutAlert()
                }
            }
            titleProfile = title
        }
    }
}
