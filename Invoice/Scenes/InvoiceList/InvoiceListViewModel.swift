//
//  InvoiceListViewModel.swift
//  Invoice
//
//  Created by Vladimir Calfa on 19/06/2022.
//

import Foundation
import Combine

class InvoiceListViewModel: InvoiceListViewModelProtocol, InvoiceListViewModelInputs, InvoiceListViewModelOutputs {
    
    var inputs: InvoiceListViewModelInputs { self }
    var outputs: InvoiceListViewModelOutputs { self }
    
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: InvoiceListViewModelProtocol
    
    @Published private(set) var title: String?
    
    @Published private var itemsWrapper: [InvoiceRecord] = []
    
    var items: Published<[InvoiceRecord]>.Publisher { $itemsWrapper }
    
    let navigateToDestination = PassthroughSubject<InvoiceListDestination, Never>()
    //MARK: -
    
    //MARK: InvoiceListViewModelProtocol
    
    let viewDidLoad = PassthroughSubject<(), Never>()
    
    let viewDidAppear = PassthroughSubject<(), Never>()
    
    let tapAddInvoice = PassthroughSubject<(), Never>()
    
    let tapDetailInvoice = PassthroughSubject<UUID, Never>()
    
    //MARK: -
    
    private var router: InvoiceListRouter
    
    init(router: InvoiceListRouter, storage: LocalStoreProtocol) {
        self.router = router
        
        outputs.navigateToDestination
            .sink(receiveValue: router.route(to:))
            .store(in: &cancellables)
        
        title = "Invoices"
        
        itemsWrapper = (1..<10).map({ InvoiceRecord(note: "Invoice \($0)") })
        
        tapAddInvoice.map({ _ -> InvoiceListDestination in .addingInvoice })
            .merge(with: tapDetailInvoice.map({ id -> InvoiceListDestination in .detailInvoice(uuid: id) }))
            .subscribe(navigateToDestination)
            .store(in: &cancellables)
    }
}
