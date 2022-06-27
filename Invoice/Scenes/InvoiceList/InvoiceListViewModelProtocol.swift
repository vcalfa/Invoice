//
//  InvoiceListViewModelProtocol.swift
//  Invoice
//
//  Created by Vladimir Calfa on 19/06/2022.
//  

import Foundation
import Combine
import CoreData

//MARK: InvoiceListViewModelInputs

protocol InvoiceListViewModelInputs {

    var viewDidLoad: PassthroughSubject<(), Never>  { get }
    
    var viewDidAppear: PassthroughSubject<(), Never>  { get }
    
    var tapAddInvoice: PassthroughSubject<(), Never>  { get }
    
    var tapDetailInvoice: PassthroughSubject<UUID, Never>  { get }
    
    var tapAddRandomInvoices: PassthroughSubject<(), Never> { get }
}


//MARK: InvoiceListViewModelOutputs

enum InvoiceListDestination {
    case addingInvoice
    case detailInvoice(uuid: UUID)
}

protocol InvoiceListViewModelOutputs {
    
    var title: String? { get }
    
    var navigateToDestination: PassthroughSubject<InvoiceListDestination, Never> { get }
    
    var managedObjectContext: NSManagedObjectContext? { get }
    
    var bgManagedObjectContext: NSManagedObjectContext? { get }
}


//MARK: InvoiceListViewModelProtocol

protocol InvoiceListViewModelProtocol: AnyObject {
    var inputs: InvoiceListViewModelInputs { get }
    var outputs: InvoiceListViewModelOutputs { get }
}
