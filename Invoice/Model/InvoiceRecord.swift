//
//  InvoiceRecord.swift
//  Invoice
//
//  Created by Vladimir Calfa on 19/06/2022.
//

import Foundation
import UIKit

struct InvoiceRecord: Hashable {
    private let identifier = UUID()
    
    let date: Date
    let total: Double
    let currency: String
    let note: String?
    let image: UIImage?
}


extension InvoiceRecord {
    
    init(note: String?) {
        self.note = note
        date = Date()
        total = 0
        currency = "SK"
        image = nil
    }
}
