//
//  CameraConfigurator.swift
//  Invoice
//
//  Created by Vladimir Calfa on 21/06/2022.
//

import Foundation

struct CameraConfigurator: ConfiguratorProtocol {
    typealias Controller = CameraViewController
    private let invoice: InvoiceItem?
    
    func configure(controller: Controller) -> Controller.ViewModelType {
        controller.sourceType = .camera
        return CameraViewModel(router: CameraRouter(controller), invoice: invoice)
    }
    
    init(invoice: InvoiceItem? = nil) {
        self.invoice = invoice
    }
}
