// NutrientsDTO.swift


/// Common Meal Nutrients
struct NutrientsDTO: Codable {
    /// Number of calories
    let calories: InfoDTO
    /// Number of fat
    let fat: InfoDTO
    /// Number of proteins
    let protein: InfoDTO
    /// Number of calories
    let chocdf: InfoDTO

    enum CodingKeys: String, CodingKey {
        case calories = "ENERC_KCAL"
        case fat = "FAT"
        case protein = "PROCNT"
        case chocdf = "CHOCDF"
    }
}
