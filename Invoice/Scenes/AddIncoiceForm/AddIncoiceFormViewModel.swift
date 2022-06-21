//
//  AddIncoiceFormViewModel.swift
//  Invoice
//
//  Created by Vladimir Calfa on 21/06/2022.
//

import Foundation
import Combine
import UIKit

class AddIncoiceFormViewModel: AddIncoiceFormViewModelInputs, AddIncoiceFormViewModelOutputs {
    
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var totalFormater: NumberFormatter = {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale.current
        return currencyFormatter
        
    }()
    
    //MARK: AddIncoiceFormViewModelProtocol
    
    @Published private(set) var title: String?
    
    @Published private(set) var image: UIImage?
    
    @Published private(set) var note: String?

    @Published private(set) var date: Date?

    @Published private(set) var total: String?
    
    @Published private(set) var action: ActionType?
    
    let navigateToDestination = PassthroughSubject<AddIncoiceFormDestination, Never>()
    //MARK: -
    
    //MARK: AddIncoiceFormViewModelProtocol
    
    let viewDidLoad = PassthroughSubject<(), Never>()
    
    let viewDidAppear = PassthroughSubject<(), Never>()
    
    let tapNavigateBack = PassthroughSubject<(), Never>()

    let tapCancel = PassthroughSubject<(), Never>()

    let tapEditPhoto = PassthroughSubject<(), Never>()
    
    let tapSaveAddAction = PassthroughSubject<(), Never>()
    
    //MARK: -
    private let router: AddIncoiceFormRouter

    init(router: AddIncoiceFormRouter, invoice: InvoiceItem? = nil) {
        self.router = router
        
        setModel(invoice)
        
        outputs.navigateToDestination
            .sink(receiveValue: router.route(to:))
            .store(in: &cancellables)

        tapNavigateBack.map({ _ -> AddIncoiceFormDestination in .navigateBack })
            .merge(with: tapCancel.map({ _ -> AddIncoiceFormDestination in .cancel }))
            .merge(with: tapEditPhoto.map({ _ -> AddIncoiceFormDestination in .editPhoto(invoice: nil) }))
            .subscribe(navigateToDestination)
            .store(in: &cancellables)
    }
    
    private func setModel(_ invoice: InvoiceItem?) {
        image = invoice?.image
        date = invoice?.date
        total = invoice.flatMap { totalFormater.string(from: NSNumber(value: $0.total)) }
        note = invoice?.note
        title = invoice?.invoiceId == nil ? "Add invoice" : "Edit invoice"
        action = invoice?.invoiceId == nil ? .add : .edit
    }
}

extension AddIncoiceFormViewModel {
    
}

extension AddIncoiceFormViewModel: AddIncoiceFormViewModelProtocol {
    
    var inputs: AddIncoiceFormViewModelInputs { self }
    var outputs: AddIncoiceFormViewModelOutputs { self }
}
