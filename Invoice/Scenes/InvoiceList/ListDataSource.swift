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
    
    private weak var collectionView: UICollectionView?
    
    private var fetchedResultsController: NSFetchedResultsController<ResultType>!
    private var diffableDataSource: UICollectionViewDiffableDataSource<Int, NSManagedObjectID>!
    
    private let managedObjectContext: NSManagedObjectContext
    
    init(collectionView: UICollectionView,
         managedObjectContext: NSManagedObjectContext,
         fetchrequest: NSFetchRequest<ResultType>,
         cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, ResultType>) {
        self.collectionView = collectionView
        self.managedObjectContext = managedObjectContext
        super.init()
        
        diffableDataSource = UICollectionViewDiffableDataSource<Int, NSManagedObjectID>(collectionView: collectionView) { [weak self]
            (collectionView, indexPath, objectID) -> UICollectionViewCell? in
//            guard let object = try? self?.managedObjectContext.existingObject(with: objectID) as? ResultType else {
//                return nil
//                fatalError("Managed object should be available")
//            }
            if objectID.isTemporaryID {
                let object = self?.managedObjectContext.object(with: objectID) as? ResultType
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: object)
            }
            
            let object = try? self?.managedObjectContext.existingObject(with: objectID) as? ResultType
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: object)
        }
        
        initializeFetchedResultsController(fetchRequest: fetchrequest)
    }
    
    private func initializeFetchedResultsController(fetchRequest: NSFetchRequest<ResultType>) {
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: managedObjectContext,
                                                              sectionNameKeyPath: nil,
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
        return try? managedObjectContext.existingObject(with: objectID) as? ResultType
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        var snapshot = snapshot as NSDiffableDataSourceSnapshot<Int, NSManagedObjectID>
        let currentSnapshot = diffableDataSource.snapshot() as NSDiffableDataSourceSnapshot<Int, NSManagedObjectID>

        let reloadIdentifiers: [NSManagedObjectID] = snapshot.itemIdentifiers.compactMap { itemIdentifier in
            guard let currentIndex = currentSnapshot.indexOfItem(itemIdentifier), let index = snapshot.indexOfItem(itemIdentifier), index == currentIndex else {
                return nil
            }
            guard let existingObject = try? managedObjectContext.existingObject(with: itemIdentifier),
                  existingObject.isUpdated
            else {
                return nil
            }
            return itemIdentifier
        }
        snapshot.reloadItems(reloadIdentifiers)

        let shouldAnimate = collectionView?.numberOfSections != 0
        diffableDataSource.apply(snapshot as NSDiffableDataSourceSnapshot<Int, NSManagedObjectID>, animatingDifferences: shouldAnimate)
    }
}
