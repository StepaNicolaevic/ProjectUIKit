// ProfileCoordinator.swift

import UIKit

/// Coordinator for Profile module
final class ProfileCoordinator: BaseModuleCoordinator {
    override func start() {
        showLogin()
    }

    func logOut() {
        finishFlowHandler?()
    }

    private func showLogin() {
        setAsRoot(publicRootController)
    }

    func showMapController() {
        let mapPresenter = MapPresenter()
        let mapView = MapViewController()
        mapView.presenter = mapPresenter
        mapPresenter.view = mapView
        mapPresenter.coordinator = self
        mapView.hidesBottomBarWhenPushed = true
        publicRootController.pushViewController(mapView, animated: false)
    }

    func popViewController() {
        publicRootController.popViewController(animated: true)
    }
}
