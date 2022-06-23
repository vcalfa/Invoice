//
//  InvoiceListConfigurator.swift
//  Invoice
//
//  Created by Vladimir Calfa on 21/06/2022.
//

import Foundation

struct InvoiceListConfigurator: ConfiguratorProtocol {
    typealias Controller = InvoiceListViewController
    
    func configure(controller: Controller) -> Controller.ViewModelType {
        return InvoiceListViewModel(router: InvoiceListRouter(controller),
                                    storage: LocalStorage.shared,
                                    invoiceManager: InvoiceManager(localStore: LocalStorage.shared,
                                                                   imageStore: ImageStore()))
    }
}
