//
//  PersistentContainer.swift
//  ShortRibs
//
//  Created by Varun Santhanam on 12/27/20.
//

#if canImport(CoreData)

import Foundation
import CoreData

/// @mockable
public protocol PersistentContaining: AnyObject {
    var name: String { get }
    var managedObejctModel: NSManagedObjectModel { get }
    var persistentStoreCoordinator: NSPersistentStoreCoordinator { get }
    var viewContext: NSManagedObjectContext { get }
    var persistentStoreDescriptions: [NSPersistentStoreDescription] { get }
    func createBackgroundContext() -> NSManagedObjectContext
    func save() throws
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void)
}

open class PersistentContainer: PersistentContaining {

    // MARK: - Initializers
    
    public convenience init(name: String) {
        self.init(.init(name: name))
    }

    public convenience init(name: String,
                            managedObjectModel model: NSManagedObjectModel) {
        self.init(.init(name: name,
                        managedObjectModel: model))
    }

    public init(_ container: NSPersistentContainer) {
        self.container = container
    }
    
    // MARK: - API
    
    open func loadPersistentStores(completionHandler block: @escaping (NSPersistentStoreDescription, Error?) -> Void) {
        container.loadPersistentStores(completionHandler: block)
    }

    // MARK: - PersistentContaining

    open var name: String {
        container.name
    }

    open var managedObejctModel: NSManagedObjectModel {
        container.managedObjectModel
    }

    open var persistentStoreCoordinator: NSPersistentStoreCoordinator {
        container.persistentStoreCoordinator
    }

    open var viewContext: NSManagedObjectContext {
        container.viewContext
    }
    
    open var persistentStoreDescriptions: [NSPersistentStoreDescription] {
        container.persistentStoreDescriptions
    }
    
    open func createBackgroundContext() -> NSManagedObjectContext {
        container.newBackgroundContext()
    }

    open func save() throws {
        let context = container.viewContext
        if context.hasChanges {
            try context.save()
        }
    }
    
    open func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        container.performBackgroundTask(block)
    }
    
    // MARK: - Private

    private let container: NSPersistentContainer
}

#endif
