// FavoritesPresenter.swift

import UIKit

/// Protocol for Favorites screen presenter
protocol FavoritesPresenterProtocol: AnyObject {
    /// Categories of product to show by view
    var recipes: [Recipe] { get }
    /// Main initializer
    init(view: FavoritesViewProtocol, coordinator: BaseModuleCoordinator, database: DataBaseProtocol)
    /// Removes recipe from recipes at index
    func removeRecipe(at indexPath: IndexPath)
}

final class FavoritesPresenter: FavoritesPresenterProtocol {
    // MARK: - Public Properties

    var recipes: [Recipe] {
        database.getFavoriteRecipes()
    }

    // MARK: - Private Properties

    private weak var coordinator: BaseModuleCoordinator?
    private weak var view: FavoritesViewProtocol?
    private var database: DataBaseProtocol

    // MARK: - Initialization

    init(view: FavoritesViewProtocol, coordinator: BaseModuleCoordinator, database: DataBaseProtocol) {
        self.view = view
        self.coordinator = coordinator
        self.database = database
    }

    // MARK: - Public Methods

    func removeRecipe(at indexPath: IndexPath) {
        let recipe = recipes[indexPath.row]
        database.removeFromFavorites(recipe)
    }
}
