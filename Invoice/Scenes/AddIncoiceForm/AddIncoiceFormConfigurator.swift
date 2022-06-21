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
    private let image: UIImage?
    
    func configure(controller: Controller) -> Controller.ViewModelType {
        let invoice = image.map({ InvoiceRecord(image: $0) })
        return AddIncoiceFormViewModel(router: AddIncoiceFormRouter(), invoice: invoice)
    }
    
    init(image: UIImage? = nil) {
        self.image = image
    }
}
