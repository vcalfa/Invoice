//
//  CameraViewModel.swift
//  Invoice
//
//  Created by Vladimir Calfa on 21/06/2022.
//

import Foundation
import UIKit
import Combine

class CameraViewModel: CameraViewModelInputs, CameraViewModelOutputs {
    
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: CameraViewModelProtocol
    
    @Published private(set) var title: String?
    
    let navigateToDestination = PassthroughSubject< CameraDestination, Never>()
    //MARK: -
    
    //MARK: CameraViewModelProtocol
    
    let viewDidLoad = PassthroughSubject<(), Never>()
    
    let viewDidAppear = PassthroughSubject<(), Never>()
    
    let actionCancel = PassthroughSubject<(), Never>()
    
    let imageDidTake = PassthroughSubject<UIImage?, Never>()
    
    //MARK: -
    
    private let router: CameraRouter
    private let invoice: InvoiceItem?
    
    init(router: CameraRouter, invoice: InvoiceItem? = nil) {
        self.router = router
        self.invoice = invoice
        
        outputs.navigateToDestination
            .sink(receiveValue: router.route(to:))
            .store(in: &cancellables)
        
        let finishAction = imageDidTake.map({ [invoice] image -> CameraDestination in
            if let invoice = invoice {
                return .finishAction(invoice: InvoiceItem(invoice: invoice, image: image))
            }
            let updatedInvoice = image.map({ InvoiceItem(image: $0) })
            return .finishAction(invoice: updatedInvoice)
        })
        
        actionCancel.map({ _ -> CameraDestination in .cancel })
            .merge(with: finishAction)
            .subscribe(navigateToDestination)
            .store(in: &cancellables)
    }
}

extension CameraViewModel {
    
}

extension CameraViewModel: CameraViewModelProtocol {
    
    var inputs: CameraViewModelInputs { self }
    var outputs: CameraViewModelOutputs { self }
}
