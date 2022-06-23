//
//  InvoiceManagerProtocol.swift
//  Invoice
//
//  Created by Vladimir Calfa on 22/06/2022.
//

import Foundation
import UIKit


protocol InvoiceManagerProtocol {
    func write(_ invoice: InvoiceItem, completition: ((Result<InvoiceItem, Error>) -> ())?)
    func getImage(for_ invoice: InvoiceItem, completition: ((Result<UIImage, Error>) -> ())?)
    func getInvoice(invoiceId: UUID, completition: ((Result<InvoiceItem, Error>) -> ())?)
}
