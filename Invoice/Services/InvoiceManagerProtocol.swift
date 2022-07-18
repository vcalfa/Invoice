//
//  InvoiceManagerProtocol.swift
//  Invoice
//
//  Created by Vladimir Calfa on 22/06/2022.
//

import Foundation
import UIKit

protocol InvoiceManagerProtocol {
    func save(_ invoice: InvoiceItem, completion: ((Result<InvoiceItem, StoreError>) -> Void)?)
    func getImage(for invoice: InvoiceItem, completion: ((Result<UIImage?, ImageStoreError>) -> Void)?)
    func getInvoice(invoiceId: UUID, completion: ((Result<InvoiceItem, StoreError>) -> Void)?)
}
