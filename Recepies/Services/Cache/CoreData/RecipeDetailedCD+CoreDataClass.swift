// RecipeDetailedCD+CoreDataClass.swift


import CoreData
import Foundation

/// Core data model for detailed recipe
public final class RecipeDetailedCD: NSManagedObject {
    @nonobjc class func fetchRequest() -> NSFetchRequest<RecipeDetailedCD> {
        NSFetchRequest<RecipeDetailedCD>(entityName: "RecipeDetailedCD")
    }

    @NSManaged var name: String?
    @NSManaged var recipeImage: String?
    @NSManaged var timeToCook: Double
    @NSManaged var calories: Double
    @NSManaged var recipeDescription: String?
    @NSManaged var weight: Double
    @NSManaged var proteins: Double
    @NSManaged var fats: Double
    @NSManaged var carbohydrates: Double
    @NSManaged var recipe: RecipeCD?
}

extension RecipeDetailedCD: Identifiable {}
