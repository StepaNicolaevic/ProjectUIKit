// Recipe.swift

/// Data related to recipe
struct Recipe: Codable {
    /// Recipe name
    let name: String
    /// Recipe image url
    let recipeImage: String
    /// Time to cook the dish
    let timeToCook: Int
    /// Calories amount
    let calories: Int
    /// Url recipe
    let uri: String
    /// Converting from DTO model
    init(_ recipeDTO: RecipeDTO) {
        uri = recipeDTO.uri
        name = recipeDTO.label
        recipeImage = recipeDTO.image
        timeToCook = recipeDTO.totalTime
        calories = Int(recipeDTO.calories)
    }

    init(recipeCD: RecipeCD) {
        name = recipeCD.name ?? ""
        uri = ""
        recipeImage = recipeCD.recipeImage ?? ""
        timeToCook = Int(recipeCD.timeToCook)
        calories = Int(recipeCD.calories)
    }
}

extension Recipe: Hashable {
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        lhs.name == rhs.name
    }
}
