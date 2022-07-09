//
//  InvoiceRecord.swift
//  Invoice
//
//  Created by Vladimir Calfa on 19/06/2022.
//

import CoreData
import Foundation
import LoremSwiftum
import UIKit

struct InvoiceItem: Hashable {
    let invoiceId: UUID?
    let date: Date?
    let total: Double?
    let currencyCode: String?
    let note: String?
    let image: UIImage?
    let imageId: UUID?
}

extension InvoiceItem {
    init(_ coreDataObject: Invoice) {
        note = coreDataObject.note
        date = coreDataObject.date
        total = coreDataObject.total?.doubleValue
        currencyCode = coreDataObject.currencyCode
        imageId = coreDataObject.imageId
        invoiceId = coreDataObject.invoiceId
        image = nil
    }

    init(invoiceId: UUID) {
        self.invoiceId = invoiceId
        date = nil
        total = nil
        currencyCode = nil
        note = nil
        image = nil
        imageId = nil
    }

    init(invoice: Self?, image: UIImage? = nil, note: String? = nil, date: Date? = nil, total: Double? = nil) {
        self.image = image ?? invoice?.image
        self.note = note ?? invoice?.note
        self.date = date ?? invoice?.date
        self.total = total ?? invoice?.total
        currencyCode = invoice?.currencyCode
        invoiceId = invoice?.invoiceId
        imageId = invoice?.imageId
    }

    init(invoice: Self, imageId: UUID? = nil) {
        image = invoice.image
        note = invoice.note
        date = invoice.date
        total = invoice.total
        currencyCode = invoice.currencyCode
        invoiceId = invoice.invoiceId
        self.imageId = imageId ?? invoice.imageId
    }
}

extension InvoiceItem {
    static func random() -> Self {
        let image = ["IMG_1529", "IMG_1530", "IMG_1531"].randomElement().flatMap { UIImage(named: $0) }
        let currency = ["CZK", "USD", "EUR", "DKK"].randomElement() ?? "EUR"
        let date = Date.randomBetween(start: Date.parse("2020-01-01"), end: Date())
        return InvoiceItem(invoiceId: nil, date: date, total: Double.random(in: 0.00 ... 9900.0), currencyCode: currency, note: Lorem.sentences(1), image: image, imageId: nil)
    }
}
