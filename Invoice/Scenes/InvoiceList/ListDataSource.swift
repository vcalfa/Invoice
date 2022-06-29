//
//  ListDataSource.swift
//  Invoice
//
//  Created by Vladimir Calfa on 23/06/2022.
//
// !!!! you should read this first: https://www.avanderlee.com/swift/diffable-data-sources-core-data/
//

import Foundation
import CoreData
import UIKit

class ListDataSource<ResultType: NSFetchRequestResult>: NSObject, NSFetchedResultsControllerDelegate where ResultType: Hashable {
    
    private typealias SectionType = String

    private weak var collectionView: UICollectionView?
    
    private var fetchedResultsController: NSFetchedResultsController<ResultType>!
    private var diffableDataSource: UICollectionViewDiffableDataSource<SectionType, NSManagedObjectID>!
    
    private let managedObjectContext: NSManagedObjectContext
    private let bgManagedObjectContext: NSManagedObjectContext
    
    init(collectionView: UICollectionView,
         managedObjectContext: NSManagedObjectContext,
         bgManagedObjectContext: NSManagedObjectContext,
         fetchrequest: NSFetchRequest<ResultType>,
         sectionNameKeyPath: String?,
         cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, ResultType>,
         headerRegistration: UICollectionView.SupplementaryRegistration<InvoceListHeaderCell>) {
        self.collectionView = collectionView
        self.managedObjectContext = managedObjectContext
        self.bgManagedObjectContext = bgManagedObjectContext
        super.init()
        
        diffableDataSource = UICollectionViewDiffableDataSource<SectionType, NSManagedObjectID>(collectionView: collectionView) { [weak self]
            (collectionView, indexPath, objectID) -> UICollectionViewCell? in
            if objectID.isTemporaryID {
                let object = self?.bgManagedObjectContext.object(with: objectID) as? ResultType
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: object)
            }
            
            let object = try? self?.bgManagedObjectContext.existingObject(with: objectID) as? ResultType
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: object)
        }
        
        diffableDataSource?.supplementaryViewProvider = { (collectionView, string, indexPath) -> InvoceListHeaderCell in
            let header = collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
            let currentSnapshot = self.diffableDataSource?.snapshot()
            let section = currentSnapshot?.sectionIdentifiers[indexPath.section]
            header.title.text = section
            return header
        }
        
        initializeFetchedResultsController(fetchRequest: fetchrequest, sectionNameKeyPath: sectionNameKeyPath)
    }
    
    private func initializeFetchedResultsController(fetchRequest: NSFetchRequest<ResultType>, sectionNameKeyPath: String?) {
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: bgManagedObjectContext,
                                                              sectionNameKeyPath: sectionNameKeyPath,
                                                              cacheName: nil)
        fetchedResultsController.delegate = self
    }
    
    func performFetch() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    func getObject(for indexPath: IndexPath) -> ResultType? {
        guard let objectID = diffableDataSource.itemIdentifier(for: indexPath) else { return nil }
        if objectID.isTemporaryID {
            let object = bgManagedObjectContext.object(with: objectID) as? ResultType
            return object
        }
        return try? bgManagedObjectContext.existingObject(with: objectID) as? ResultType
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        var snapshot = snapshot as NSDiffableDataSourceSnapshot<SectionType, NSManagedObjectID>
        let currentSnapshot = diffableDataSource.snapshot() as NSDiffableDataSourceSnapshot<SectionType, NSManagedObjectID>

        let reloadIdentifiers: [NSManagedObjectID] = snapshot.itemIdentifiers.compactMap { itemIdentifier in
            guard let currentIndex = currentSnapshot.indexOfItem(itemIdentifier), let index = snapshot.indexOfItem(itemIdentifier), index == currentIndex else {
                return nil
            }
            
            if itemIdentifier.isTemporaryID {
                let object = bgManagedObjectContext.object(with: itemIdentifier)
                if object.isUpdated {
                    return itemIdentifier
                }
            }
            
            guard let existingObject = try? bgManagedObjectContext.existingObject(with: itemIdentifier),
                  existingObject.isUpdated
            else {
                return nil
            }
            return itemIdentifier
        }
        snapshot.reloadItems(reloadIdentifiers)

        DispatchQueue.main.async {
            let shouldAnimate = self.collectionView?.numberOfSections != 0
            self.diffableDataSource.apply(snapshot as NSDiffableDataSourceSnapshot<SectionType, NSManagedObjectID>, animatingDifferences: shouldAnimate)
        }
    }
}
