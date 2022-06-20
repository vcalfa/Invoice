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
    
    //MARK: InvoiceListViewModelProtocol
    
    @Published private(set) var title: String?
    
    @Published private var itemsWrapper: [InvoiceRecord] = []

    // var itemsPublished: Published<[InvoiceRecord]> { _items }
    
    var items: Published<[InvoiceRecord]>.Publisher { $itemsWrapper }
    
    //MARK: -
    
    //MARK: InvoiceListViewModelProtocol
    
    let viewDidLoad = PassthroughSubject<(), Never>()
    
    let viewDidAppear = PassthroughSubject<(), Never>()
    
    //MARK: -
    
    init() {
        title = "Invoices"
        itemsWrapper = (1..<10).map({ InvoiceRecord(note: "Invoice \($0)") })
    }
}
