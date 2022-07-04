//
//  Invoice+CoreDataClass.swift
//  Invoice
//
//  Created by Vladimir Calfa on 22/06/2022.
//
//

import CoreData
import Foundation

@objc(Invoice)
public class Invoice: NSManagedObject {
    func update(with item: InvoiceItem) {
        note = item.note
        date = item.date
        section = date?.section()
        total = item.total.map { NSNumber(value: $0) }
        imageId = item.imageId
        currencyCode = item.currencyCode
    }
}

private extension Date {
    func section() -> Date {
        let components = Calendar.current.dateComponents([.year, .month], from: self)
        guard let date = Calendar.current.date(from: components) else {
            fatalError("Failed to strip time from Date object")
        }
        return date
    }
}
