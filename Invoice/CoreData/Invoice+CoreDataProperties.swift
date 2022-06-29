//
//  Invoice+CoreDataProperties.swift
//  Invoice
//
//  Created by Vladimir Calfa on 28/06/2022.
//
//

import Foundation
import CoreData


extension Invoice {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Invoice> {
        return NSFetchRequest<Invoice>(entityName: "Invoice")
    }

    @NSManaged public var currencyCode: String?
    @NSManaged public var date: Date?
    @NSManaged public var imageId: UUID?
    @NSManaged public var invoiceId: UUID?
    @NSManaged public var note: String?
    @NSManaged public var total: NSNumber?

}

extension Invoice : Identifiable {

}
