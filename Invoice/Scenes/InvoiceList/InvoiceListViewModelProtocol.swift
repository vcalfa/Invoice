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
}


//MARK: InvoiceListViewModelOutputs

protocol InvoiceListViewModelOutputs {
    
    var title: String? { get }
    
    //var items: Array<InvoiceRecord> { get }
    
    // Define name Published property wrapper
    // var itemsPublished: Published<Array<InvoiceRecord>> { get }
    
    // Define name publisher
    // var itemsPublisher: Published<Array<InvoiceRecord>>.Publisher { get }
    var items: Published<Array<InvoiceRecord>>.Publisher { get }
}


//MARK: InvoiceListViewModelProtocol

protocol InvoiceListViewModelProtocol: AnyObject {
    var inputs: InvoiceListViewModelInputs { get }
    var outputs: InvoiceListViewModelOutputs { get }
}
