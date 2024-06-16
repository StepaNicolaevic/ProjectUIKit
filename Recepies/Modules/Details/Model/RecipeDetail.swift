// RecipeDetail.swift

/// Recipe details
struct RecipeDetail {
    /// Recipe name
    let name: String
    /// Recipe image
    let recipeImage: String
    /// Time to prepare the dish
    let timeToCook: Double
    /// Number of calories
    let calories: Double
    /// Detailed recipe
    let description: String
    /// Weight of the dish
    let weight: Double
    /// Proteins
    let proteins: Double
    /// Fats
    let fats: Double
    /// Carbohydrates
    let carbohydrates: Double
    /// Convert from DTO model
    init(dto: RecipeDetailDTO) {
        name = dto.label
        timeToCook = dto.totalTime
        recipeImage = dto.image
        description = dto.ingredientLines.joined(separator: "recipeDescription/n")
        weight = dto.totalWeight
        calories = dto.totalNutrients.calories.quantity
        proteins = dto.totalNutrients.protein.quantity
        fats = dto.totalNutrients.fat.quantity
        carbohydrates = dto.totalNutrients.chocdf.quantity
    }

    init(detailCD: RecipeDetailedCD) {
        name = detailCD.name ?? ""
        timeToCook = detailCD.timeToCook
        recipeImage = detailCD.recipeImage ?? ""
        description = detailCD.recipeDescription ?? ""
        weight = detailCD.weight
        calories = detailCD.calories
        proteins = detailCD.proteins
        fats = detailCD.fats
        carbohydrates = detailCD.carbohydrates
    }
}
