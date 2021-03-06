//
//  LocalStorageProtocol.swift
//  Invoice
//
//  Created by Vladimir Calfa on 19/06/2022.
//

import CoreData
import Foundation

protocol LocalStoreProtocol {
    var viewContext: NSManagedObjectContext { get }
    var bgViewContext: NSManagedObjectContext! { get }

    func fetchAllInvoices() -> [Invoice]?
    func fetch(invoiceId: UUID?) -> Invoice?
    func save(invoice: InvoiceItem, completion: ((Result<InvoiceItem, Error>) -> Void)?)
}
