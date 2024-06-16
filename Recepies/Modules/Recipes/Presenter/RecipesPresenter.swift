// RecipesPresenter.swift

import Foundation

/// Protocol for recipe screen presenter
protocol RecipesPresenterProtocol: AnyObject {
    /// Initialization
    init(view: RecipesViewProtocol, coordinator: BaseModuleCoordinator)
    /// Coordinator
    var coordinator: BaseModuleCoordinator? { get set }
    /// Recipe data
    var category: [Category] { get set }
    /// Getting the index of the selected cell
    func transitionToCategory(index: Int)
}

/// Presenter for recipes screen
final class RecipesPresenter: RecipesPresenterProtocol {
    // MARK: - Public Properties

    var category: [Category] = Category.makeCategories()

    // MARK: - Private Properties

    private weak var view: RecipesViewProtocol?
    weak var coordinator: BaseModuleCoordinator?

    // MARK: - Initializers

    init(view: RecipesViewProtocol, coordinator: BaseModuleCoordinator) {
        self.view = view
        self.coordinator = coordinator
    }

    // MARK: - Public Methods

    func transitionToCategory(index: Int) {
        let selectedCategory = category[index]
        if let recipesCoordinator = coordinator as? RecipesCoordinator {
            recipesCoordinator.showCategoryScren(category: selectedCategory)
        }
    }
}
