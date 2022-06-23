//
//  InvoiceRecord.swift
//  Invoice
//
//  Created by Vladimir Calfa on 19/06/2022.
//

import Foundation
import UIKit
import CoreData

struct InvoiceItem: Hashable {
    let identifier = UUID()
    
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
        total = coreDataObject.total
        currencyCode = coreDataObject.currencyCode
        imageId = coreDataObject.imageId
        invoiceId = coreDataObject.invoiceId
        image = nil
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
}
