//
//  InvoiceManager.swift
//  Invoice
//
//  Created by Vladimir Calfa on 22/06/2022.
//

import Foundation
import UIKit


class InvoiceManager: InvoiceManagerProtocol {
    
    private let localStore: LocalStoreProtocol
    private let imageStore: ImageStoreProtocol
    
    public init(localStore: LocalStoreProtocol, imageStore: ImageStoreProtocol) {
        self.localStore = localStore
        self.imageStore = imageStore
    }
    
    func write(_ invoice: InvoiceItem, completition: ((Result<InvoiceItem, Error>) -> ())?) {
        
    }
    
    func getImage(for_ invoice: InvoiceItem, completition: ((Result<UIImage, Error>) -> ())?) {
        
    }
    
    func getInvoice(invoiceId: UUID, completition: ((Result<InvoiceItem, Error>) -> ())?) {
        
    }
}
