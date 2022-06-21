//
//  InvoiceRecord.swift
//  Invoice
//
//  Created by Vladimir Calfa on 19/06/2022.
//

import Foundation
import UIKit

struct InvoiceItem: Hashable {
    let identifier = UUID()
    
    let invoiceId: UUID?
    let date: Date
    let total: Double
    let currency: String
    let note: String?
    let image: UIImage?
}


extension InvoiceItem {
    
    init(note: String?) {
        self.note = note
        date = Date()
        total = 0
        currency = "SK"
        image = nil
        invoiceId = nil
    }
    
    init(invoice: Self, image: UIImage?) {
        self.image = image
        note = invoice.note
        date = invoice.date
        total = invoice.total
        currency = invoice.currency
        invoiceId = invoice.invoiceId
    }
    
    init(image: UIImage?) {
        self.image = image
        note = nil
        date = Date()
        total = 0
        currency = "SK"
        invoiceId = nil
    }
}
