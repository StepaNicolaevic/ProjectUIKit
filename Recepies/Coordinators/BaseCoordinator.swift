// BaseCoordinator.swift

import UIKit

/// Base class for App coordinator
class BaseCoodinator {
    // MARK: - Public Properties

    /// Coordinators to route in app's coordinator as childs
    var childCoordinators: [BaseCoodinator] = []

    // MARK: - Public Methods

    /// Method to show the first view in module
    func start() {
        fatalError("child должен быть реализован")
    }

    /// Add new coordinator to childCoordinators
    func add(coordinator: BaseCoodinator) {
        childCoordinators.append(coordinator)
    }

    /// Remove coordinator from childCoordinators
    func remove(coordinator: BaseCoodinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }

    /// Set controller as rootViewController for app's window
    func setAsRoot(_ controller: UIViewController) {
        let window = UIApplication
            .shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .last { $0.isKeyWindow }
        window?.rootViewController = controller
    }
}

/// Base class to inherit for modules coordinators
class BaseModuleCoordinator: BaseCoodinator {
    /// Root controller for nested UINavigationController
    private var rootController: UINavigationController?
    var publicRootController: UINavigationController {
        if let rootController {
            return rootController
        } else {
            return UINavigationController()
        }
    }

    /// Action to finish navigation flow
    var finishFlowHandler: VoidHandler?
    /// Injecting rootViewController
    func setRootController(_ rootController: UIViewController) {
        self.rootController = UINavigationController(rootViewController: rootController)
    }
}
