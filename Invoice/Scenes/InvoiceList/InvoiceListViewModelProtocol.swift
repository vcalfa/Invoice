//
//  InvoiceListViewModelProtocol.swift
//  Invoice
//
//  Created by Vladimir Calfa on 19/06/2022.
//

import Foundation
import Combine

//MARK: InvoiceListViewModelInputs

protocol InvoiceListViewModelInputs {

    var viewDidLoad: PassthroughSubject<(), Never>  { get }
    
    var viewDidAppear: PassthroughSubject<(), Never>  { get }
    
    var tapAddInvoice: PassthroughSubject<(), Never>  { get }
    
    var tapDetailInvoice: PassthroughSubject<UUID, Never>  { get }
}


//MARK: InvoiceListViewModelOutputs

enum InvoiceListDestination {
    case addingInvoice
    case detailInvoice(uuid: UUID)
}

protocol InvoiceListViewModelOutputs {
    
    var title: String? { get }
    
    var items: Published<[InvoiceItem]?>.Publisher { get }
    
    var navigateToDestination: PassthroughSubject<InvoiceListDestination, Never> { get }
}


//MARK: InvoiceListViewModelProtocol

protocol InvoiceListViewModelProtocol: AnyObject {
    var inputs: InvoiceListViewModelInputs { get }
    var outputs: InvoiceListViewModelOutputs { get }
}
