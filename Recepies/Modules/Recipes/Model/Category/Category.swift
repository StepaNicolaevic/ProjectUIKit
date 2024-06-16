// Category.swift


/// Main ingredient of the recipe
struct Category {
    /// Type of category
    let type: CategoryType
    /// Category name
    var name: String {
        type.rawValue.capitalized
    }

    /// Category image
    var categoryImage: String {
        type.rawValue
    }

    /// Filling in category data
    static func makeCategories() -> [Category] {
        CategoryType.allCases.map { Category(type: $0) }
    }
}
