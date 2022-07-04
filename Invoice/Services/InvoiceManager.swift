//
//  InvoiceManager.swift
//  Invoice
//
//  Created by Vladimir Calfa on 22/06/2022.
//

import Foundation
import UIKit

enum StoreError: Error {
    case notFound
    case notSaved
}

class InvoiceManager: InvoiceManagerProtocol {
    private let localStore: LocalStoreProtocol
    private let imageStore: ImageStoreProtocol

    private let savaQueue = DispatchQueue(label: "InvoiceManager.save", qos: .utility)

    public init(localStore: LocalStoreProtocol, imageStore: ImageStoreProtocol) {
        self.localStore = localStore
        self.imageStore = imageStore
    }

    func save(_ invoice: InvoiceItem, completition: ((Result<InvoiceItem, StoreError>) -> Void)?) {
        savaQueue.async { [weak self] in
            guard let self = self else {
                completition?(.failure(.notSaved))
                return
            }

            let imageSaveResult = self.saveImage(invoice)

            let imageId = imageSaveResult.flatMap { try? $0.get() }
            let saveInvoice = InvoiceItem(invoice: invoice, imageId: imageId)

            self.localStore.save(invoice: saveInvoice) { result in
                switch result {
                case .success:
                    completition?(.success(invoice))
                case .failure:
                    completition?(.failure(.notSaved))
                }
            }
        }
    }

    private func saveImage(_ invoice: InvoiceItem) -> Result<UUID, ImageStoreError>? {
        guard let image = invoice.image else { return nil }

        return imageStore.save(image: image, uuid: invoice.imageId)
    }

    func getImage(for invoice: InvoiceItem, completition: ((Result<UIImage?, ImageStoreError>) -> Void)?) {
        guard let imageId = invoice.imageId else {
            completition?(.success(invoice.image))
            return
        }

        let result = imageStore.fetch(imageId: imageId)
        switch result {
        case let .success((image, _)): completition?(.success(image))
        case let .failure(error): completition?(.failure(error))
        }
    }

    func getInvoice(invoiceId: UUID, completition: ((Result<InvoiceItem, StoreError>) -> Void)?) {
        guard let storedInvoice = localStore.fetch(invoiceId: invoiceId) else {
            completition?(.failure(.notFound))
            return
        }

        completition?(.success(InvoiceItem(storedInvoice)))
    }
}
