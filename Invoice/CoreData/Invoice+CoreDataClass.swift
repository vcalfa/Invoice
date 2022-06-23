//
//  Invoice+CoreDataClass.swift
//  Invoice
//
//  Created by Vladimir Calfa on 22/06/2022.
//
//

import Foundation
import CoreData

@objc(Invoice)
public class Invoice: NSManagedObject {

    func update(with item: InvoiceItem) {
        note = item.note
        date = item.date
        total = item.total.map{ NSNumber(value: $0) }
        imageId = item.imageId
        currencyCode = item.currencyCode
    }
}
