// CategoryCD+CoreDataClass.swift


import CoreData
import Foundation

/// Core data model for recipe
public final class CategoryCD: NSManagedObject {
    @nonobjc class func fetchRequest() -> NSFetchRequest<CategoryCD> {
        NSFetchRequest<CategoryCD>(entityName: "CategoryCD")
    }

    @NSManaged var name: String?
    @NSManaged var recipesSet: Set<RecipeCD>?

    // MARK: Generated accessors for recipes

    @objc(addRecipesObject:)
    @NSManaged func addToRecipes(_ value: RecipeCD)

    @objc(removeRecipesObject:)
    @NSManaged func removeFromRecipes(_ value: RecipeCD)

    @objc(addRecipes:)
    @NSManaged func addToRecipes(_ valuesSet: Set<RecipeCD>)

    @objc(removeRecipes:)
    @NSManaged func removeFromRecipes(_ valuesSet: Set<RecipeCD>)
}

extension CategoryCD: Identifiable {}
