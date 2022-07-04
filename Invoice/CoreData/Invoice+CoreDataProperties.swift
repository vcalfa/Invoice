//
//  Invoice+CoreDataProperties.swift
//  Invoice
//
//  Created by Vladimir Calfa on 28/06/2022.
//
//

import CoreData
import Foundation

public extension Invoice {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Invoice> {
        return NSFetchRequest<Invoice>(entityName: "Invoice")
    }

    @NSManaged var currencyCode: String?
    @NSManaged var date: Date?
    @NSManaged var imageId: UUID?
    @NSManaged var invoiceId: UUID?
    @NSManaged var note: String?
    @NSManaged var total: NSNumber?
    @NSManaged var section: Date?
}

extension Invoice: Identifiable {}
