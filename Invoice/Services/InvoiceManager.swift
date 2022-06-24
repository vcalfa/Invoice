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
    case notFound
}

class InvoiceManager: InvoiceManagerProtocol {
    
    private let localStore: LocalStoreProtocol
    private let imageStore: ImageStoreProtocol
    
    public init(localStore: LocalStoreProtocol, imageStore: ImageStoreProtocol) {
        self.localStore = localStore
        self.imageStore = imageStore
    }
    
    func save(_ invoice: InvoiceItem, completition: ((Result<InvoiceItem, StoreError>) -> ())?) {
        guard let managedContext = localStore.getContext else {
            completition?(.failure(.crazyCoreData))
            return
        }
        
        let result = saveImage(invoice)
        var storedInvoice = localStore.fetch(invoiceId: invoice.invoiceId)
        if let updateInvoice = storedInvoice {
            updateInvoice.update(with: invoice)
        } else {
            let newInvoice = Invoice(context: managedContext)
            newInvoice.invoiceId = UUID()
            newInvoice.update(with: invoice)
            newInvoice.imageId = result.flatMap({ try? $0.get() })
            storedInvoice = newInvoice
        }
        
        do {
            try managedContext.save()
            completition?(.success(invoice))
        } catch let error as NSError {
            dump("Failed to save session data! \(error): \(error.userInfo)")
            completition?(.failure(.crazyCoreData))
        }
    }
    
    private func saveImage(_ invoice: InvoiceItem) -> Result<UUID, ImageStoreError>? {
        
        guard let image = invoice.image else { return nil }
        
        return imageStore.save(image: image, uuid: invoice.imageId)
    }
    
    func getImage(for invoice: InvoiceItem, completition: ((Result<UIImage?, ImageStoreError>) -> ())?) {
        
        guard let imageId = invoice.imageId else {
            completition?(.success(invoice.image))
            return
        }
        
        let result = imageStore.fetch(imageId: imageId)
        switch result {
        case .success((let image, _)): completition?(.success(image))
        case .failure(let error): completition?(.failure(error))
        }
    }
    
    func getInvoice(invoiceId: UUID, completition: ((Result<InvoiceItem, StoreError>) -> ())?) {
        
        guard let storedInvoice = localStore.fetch(invoiceId: invoiceId) else {
            completition?(.failure(.notFound))
            return
        }
        
        completition?(.success(InvoiceItem(storedInvoice)))
    }
}
