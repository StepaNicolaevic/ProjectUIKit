// RecipeDetailDTO.swift


/// Structure representing information about a dish
struct RecipeDetailDTO: Codable {
    /// Recipe name
    let label: String
    /// Recipe image
    let image: String
    /// Time to prepare the dish
    let totalTime: Double
    /// Detailed recipe
    let ingredientLines: [String]
    /// Weight of the dish
    let totalWeight: Double
    /// All Nutrients
    let totalNutrients: NutrientsDTO
}
