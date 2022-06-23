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
    
    func configure(controller: Controller) -> Controller.ViewModelType {
        return AddIncoiceFormViewModel(router: AddIncoiceFormRouter(controller),
                                       invoiceManager: InvoiceManager(localStore: LocalStorage.shared,
                                                                      imageStore: ImageStore()),
                                       invoice: invoice)
    }
    
    init(invoice: InvoiceItem? = nil) {
        self.invoice = invoice
    }
}
