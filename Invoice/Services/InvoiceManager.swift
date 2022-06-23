//
//  InvoiceManager.swift
//  Invoice
//
//  Created by Vladimir Calfa on 22/06/2022.
//

import Foundation
import UIKit

enum StoreError: Error {
    case crazyCoreData
}

class InvoiceManager: InvoiceManagerProtocol {
    
    private let localStore: LocalStoreProtocol
    private let imageStore: ImageStoreProtocol
    
    public init(localStore: LocalStoreProtocol, imageStore: ImageStoreProtocol) {
        self.localStore = localStore
        self.imageStore = imageStore
    }
    
    func write(_ invoice: InvoiceItem, completition: ((Result<InvoiceItem, StoreError>) -> ())?) {
        guard let managedContext = localStore.getContext else {
            completition?(.failure(.crazyCoreData))
            return
        }
        
        if let updateInvoice = localStore.fetch(invoiceId: invoice.invoiceId) {
            updateInvoice.update(with: invoice)
        } else {
            let newInvoice = Invoice(context: managedContext)
            newInvoice.invoiceId = UUID()
            newInvoice.update(with: invoice)
        }
        
        do {
            try managedContext.save()
            completition?(.success(invoice))
        } catch let error as NSError {
            dump("Failed to save session data! \(error): \(error.userInfo)")
            completition?(.failure(.crazyCoreData))
        }
    }
    
    func getImage(for_ invoice: InvoiceItem, completition: ((Result<UIImage, Error>) -> ())?) {
        
    }
    
    func getInvoice(invoiceId: UUID, completition: ((Result<InvoiceItem, Error>) -> ())?) {
        
    }
}
