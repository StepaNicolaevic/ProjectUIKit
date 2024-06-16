// RecipeDTO.swift


/// DTO for recipe
struct RecipeDTO: Codable {
    /// Base link for detailed search
    let uri: String
    /// Recipe name
    let label: String
    /// Recipe image url
    let image: String
    /// Calories amount
    let calories: Double
    /// Cooking time
    let totalTime: Int
}
