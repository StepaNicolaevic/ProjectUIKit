// RecipeCD+CoreDataClass.swift


import CoreData
import Foundation

/// Core data model for recipe
public final class RecipeCD: NSManagedObject {
    @nonobjc class func fetchRequest() -> NSFetchRequest<RecipeCD> {
        NSFetchRequest<RecipeCD>(entityName: "RecipeCD")
    }

    @NSManaged var name: String?
    @NSManaged var recipeImage: String?
    @NSManaged var timeToCook: Int64
    @NSManaged var calories: Int64
    @NSManaged var category: String
//    @NSManaged var recipeDetailed: RecipeDetailedCD?
}

extension RecipeCD: Identifiable {}
