// CoreDataManager.swift


import CoreData
import Foundation

final class CoreDataManager {
    // MARK: - Singletone

    static let shared = CoreDataManager()
    private init() {}

    // MARK: - Piblic Properties

    lazy var context = persistentContainer.viewContext
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Recepies")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                print("Persistent container error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Public Methods

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Failed to save context \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
