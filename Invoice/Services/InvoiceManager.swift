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

    private let saveQueue = DispatchQueue(label: "InvoiceManager.save", qos: .utility)

    public init(localStore: LocalStoreProtocol, imageStore: ImageStoreProtocol) {
        self.localStore = localStore
        self.imageStore = imageStore
    }

    func save(_ invoice: InvoiceItem, completion: ((Result<InvoiceItem, StoreError>) -> Void)?) {
        saveQueue.async { [weak self] in
            guard let self = self else {
                completion?(.failure(.notSaved))
                return
            }

            let imageSaveResult = self.saveImage(invoice)

            let imageId = imageSaveResult.flatMap { try? $0.get() }
            let saveInvoice = InvoiceItem(invoice: invoice, imageId: imageId)

            self.localStore.save(invoice: saveInvoice) { result in
                switch result {
                case .success:
                    completion?(.success(invoice))
                case .failure:
                    completion?(.failure(.notSaved))
                }
            }
        }
    }

    private func saveImage(_ invoice: InvoiceItem) -> Result<UUID, ImageStoreError>? {
        guard let image = invoice.image else { return nil }

        return imageStore.save(image: image, uuid: invoice.imageId)
    }

    func getImage(for invoice: InvoiceItem, completion: ((Result<UIImage?, ImageStoreError>) -> Void)?) {
        guard let imageId = invoice.imageId else {
            completion?(.success(invoice.image))
            return
        }

        let result = imageStore.fetch(imageId: imageId)
        switch result {
        case let .success((image, _)): completion?(.success(image))
        case let .failure(error): completion?(.failure(error))
        }
    }

    func getInvoice(invoiceId: UUID, completion: ((Result<InvoiceItem, StoreError>) -> Void)?) {
        guard let storedInvoice = localStore.fetch(invoiceId: invoiceId) else {
            completion?(.failure(.notFound))
            return
        }

        completion?(.success(InvoiceItem(storedInvoice)))
    }
}
