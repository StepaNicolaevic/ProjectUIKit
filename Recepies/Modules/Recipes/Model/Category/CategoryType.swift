// CategoryType.swift


import Foundation

/// Describe types of categories
enum CategoryType: String, CaseIterable {
    /// Sakad dishes
    case salad
    /// Soup dishes
    case soup
    /// Chicken dishes
    case chicken
    /// Meat dishes
    case meat
    /// Fish dishes
    case fish
    /// Side dishes
    case sideDish = "side Dish"
    /// Panckake dishes
    case pancake
    /// Drinks
    case drinks
    /// Dessert dishes
    case desserts
    /// Describe category name, used in Category model and search through RestAPI
    var description: String {
        switch self {
        case .chicken, .meat, .sideDish, .fish:
            return "Main course"
        default:
            return rawValue.capitalized
        }
    }
}
