//
//  CameraConfigurator.swift
//  Invoice
//
//  Created by Vladimir Calfa on 21/06/2022.
//

import Foundation
import UIKit

struct CameraConfigurator: ConfiguratorProtocol {
    typealias Controller = CameraViewController
    private let invoice: InvoiceItem?
    
    func configure(controller: Controller) -> Controller.ViewModelType {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            controller.sourceType = .camera
        } else {
            controller.sourceType = .photoLibrary
        }
        
        return CameraViewModel(router: CameraRouter(controller), invoice: invoice)
    }
    
    init(invoice: InvoiceItem? = nil) {
        self.invoice = invoice
    }
}
