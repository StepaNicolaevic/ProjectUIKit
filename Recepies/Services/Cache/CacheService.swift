// CacheService.swift


import CoreData
import Foundation

/// Protocol for cashe recipes service
protocol CacheServiceProtocol {
    func fetchRecipes(for category: Category) -> [Recipe]
    func fetchDetailedRecipe(for recipe: Recipe) -> RecipeDetail?
    func save(recipes: [Recipe], to category: Category)
    func save(recipeDetailed: RecipeDetail /* , to recipe: Recipe */ )
    func removeAllRecipes()
}

final class CacheService {
    let coreDataManager: CoreDataManager

    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
}

// MARK: - CacheService - CacheServiceProtocol

extension CacheService: CacheServiceProtocol {
    func save(recipes: [Recipe], to category: Category) {
        guard let recipeEntityDescription = NSEntityDescription.entity(
            forEntityName: "RecipeCD",
            in: coreDataManager.context
        ) else { return }
        for recipe in recipes {
            let recipeCD = RecipeCD(entity: recipeEntityDescription, insertInto: coreDataManager.context)
            recipeCD.name = recipe.name
            recipeCD.calories = Int64(recipe.calories)
            recipeCD.timeToCook = Int64(recipe.timeToCook)
            recipeCD.recipeImage = recipe.recipeImage
            recipeCD.category = category.name
            coreDataManager.saveContext()
        }
    }

    func save(recipeDetailed: RecipeDetail /* , to recipe: Recipe? */ ) {
        guard let recipeEntityDescription = NSEntityDescription.entity(
            forEntityName: "RecipeDetailedCD",
            in: coreDataManager.context
        )
        else { return }
        let recipeDetaiCD = RecipeDetailedCD(entity: recipeEntityDescription, insertInto: coreDataManager.context)
        recipeDetaiCD.name = recipeDetailed.name
        recipeDetaiCD.calories = recipeDetailed.calories
        recipeDetaiCD.carbohydrates = recipeDetailed.carbohydrates
        recipeDetaiCD.recipeImage = recipeDetailed.recipeImage
        recipeDetaiCD.fats = recipeDetailed.fats
        recipeDetaiCD.timeToCook = recipeDetailed.timeToCook
        recipeDetaiCD.recipeDescription = recipeDetailed.description
        recipeDetaiCD.weight = recipeDetailed.weight
        recipeDetaiCD.proteins = recipeDetailed.proteins
        coreDataManager.saveContext()
    }

    func fetchDetailedRecipe(for recipe: Recipe) -> RecipeDetail? {
        do {
            let recipes = try? coreDataManager.context.fetch(RecipeDetailedCD.fetchRequest())
            guard let recipes = recipes else { return nil }
            for item in recipes {
                if item.name == recipe.name {
                    return RecipeDetail(detailCD: item)
                }
            }
            return nil
        }
    }

    func fetchRecipes(for category: Category) -> [Recipe] {
        do {
            let recipes = try? coreDataManager.context.fetch(RecipeCD.fetchRequest())
            guard let categoryRecipes = recipes?.filter({ $0.category == category.name }) else { return [] }
            return categoryRecipes.map { Recipe(recipeCD: $0) }
        }
    }

    func removeAllRecipes() {}
}
