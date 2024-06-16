// AuthCoordinator.swift

import UIKit

/// Coordinator for Auth module
final class AuthCoordinator: BaseModuleCoordinator {
    override func start() {
        showLogin()
    }

    func finishFlow() {
        finishFlowHandler?()
    }

    func showTabBar() {
        finishFlowHandler?()
    }

    private func showLogin() {
        setAsRoot(publicRootController)
    }
}
