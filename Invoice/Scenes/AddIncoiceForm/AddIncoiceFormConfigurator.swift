//
//  AddIncoiceFormConfigurator.swift
//  Invoice
//
//  Created by Vladimir Calfa on 21/06/2022.
//

import Foundation
import UIKit

struct AddIncoiceFormConfigurator: ConfiguratorProtocol {
    typealias Controller = AddIncoiceFormViewController
    private let invoice: InvoiceItem?
    private let invoiceId: UUID?

    func configure(controller: Controller) -> Controller.ViewModelType {
        return AddIncoiceFormViewModel(router: AddIncoiceFormRouter(controller),
                                       invoiceManager: InvoiceManager(localStore: LocalStorage.shared,
                                                                      imageStore: ImageStore()),
                                       invoice: invoice,
                                       invoiceID: invoiceId)
    }

    init(invoice: InvoiceItem? = nil, invoiceId: UUID? = nil) {
        self.invoice = invoice
        self.invoiceId = invoiceId
    }
}
