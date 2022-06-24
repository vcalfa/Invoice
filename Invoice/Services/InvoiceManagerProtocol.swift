//
//  InvoiceManagerProtocol.swift
//  Invoice
//
//  Created by Vladimir Calfa on 22/06/2022.
//

import Foundation
import UIKit


protocol InvoiceManagerProtocol {
    func save(_ invoice: InvoiceItem, completition: ((Result<InvoiceItem, StoreError>) -> ())?)
    func getImage(for invoice: InvoiceItem, completition: ((Result<UIImage?, ImageStoreError>) -> ())?)
    func getInvoice(invoiceId: UUID, completition: ((Result<InvoiceItem, StoreError>) -> ())?)
}
