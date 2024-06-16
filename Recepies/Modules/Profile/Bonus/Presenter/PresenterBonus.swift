// PresenterBonus.swift

import Foundation

///  Protocol for bonus screen presenter
protocol BonusPresenterProtocol: AnyObject {
    /// Closing the bonus screen
    func dismisView()
}

protocol BonusViewProtocol: AnyObject {
    /// Call to close the screen
    func closeView()
}

final class BonusPresenter: BonusPresenterProtocol {
    // MARK: - Public Properties

    weak var view: BonusViewProtocol?

    // MARK: - Public Methods

    func dismisView() {
        view?.closeView()
    }
}
