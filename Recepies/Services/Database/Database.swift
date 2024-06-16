// Database.swift


import Foundation

/// Protocol for storage service
protocol DataBaseProtocol {
    /// Adds recipe to favorites
    ///  - Parameter recipe: recipe model
    ///  - Returns true is success, false if not added to favorites
    func addToFavorites(_ recipe: Recipe)
    /// Remove recipe from favorites
    ///  - Parameter recipe: recipe model
    ///  - Returns true is success, false if not removed from favorites
    func removeFromFavorites(_ recipe: Recipe)
    /// Check if favorites contain recipe
    ///  - Parameter recipe: recipe model
    ///  - Returns true is contain, false if not
    func isFavorite(_ recipe: Recipe) -> Bool
    /// Provide array of recipes from internal storage
    ///  - Returns array of favorite recipe
    func getFavoriteRecipes() -> [Recipe]
    /// Download saved recipes from userDefaults
    func setFromUserDefaults()
    /// Save changes to userDefaults
    func saveToUserDefaults()
}

/// Storage for recipes and categories
final class Database: DataBaseProtocol {
    // MARK: - Singletone

    static let shared = Database()

    // MARK: - Private Properties

    private let key = "Recipes"
    private let defaults = UserDefaults.standard
    private var recipesSet: Set<Recipe> = []

    // MARK: - Initialization

    private init() {
        setFromUserDefaults()
    }

    // MARK: - DataBaseProtocol

    func addToFavorites(_ recipe: Recipe) {
        recipesSet.insert(recipe)
    }

    func removeFromFavorites(_ recipe: Recipe) {
        recipesSet.remove(recipe)
    }

    func isFavorite(_ recipe: Recipe) -> Bool {
        recipesSet.contains(recipe)
    }

    func getFavoriteRecipes() -> [Recipe] {
        Array(recipesSet)
    }

    func setFromUserDefaults() {
        guard let data = defaults.object(forKey: key) as? Data,
              let recipes = dataToRecipe(data)
        else {
            recipesSet = []
            return
        }
        recipesSet = Set(recipes)
    }

    func saveToUserDefaults() {
        let recipes = Array(recipesSet)
        let data = recipeToData(recipes)
        defaults.setValue(data, forKey: key)
    }
}

// MARK: - Convertig data

private extension Database {
    func recipeToData(_ recipes: [Recipe]) -> Data? {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(recipes)
            return data
        } catch {
            print("Error decoding Recipe to data: \(error)")
        }
        return nil
    }

    func dataToRecipe(_ data: Data) -> [Recipe]? {
        let decoder = JSONDecoder()
        do {
            let recipe = try decoder.decode([Recipe].self, from: data)
            return recipe
        } catch {
            print("Error decoding data to Recipe: \(error)")
        }
        return nil
    }
}
