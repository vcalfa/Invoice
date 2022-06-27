//
//  LocalStorageProtocol.swift
//  Invoice
//
//  Created by Vladimir Calfa on 19/06/2022.
//

import Foundation
import CoreData

protocol LocalStoreProtocol {
    
    var viewContext: NSManagedObjectContext { get }

    func fetchAllInvoices() -> [Invoice]?
    func fetch(invoiceId: UUID?) -> Invoice?
    func save(invoice: InvoiceItem, completition: ((Result<InvoiceItem, Error>) -> ())?)
}
