//
//  AddIncoiceFormViewModelProtocol.swift
//  Invoice
//
//  Created by Vladimir Calfa on 21/06/2022.
//

import Combine

//MARK: AddIncoiceFormViewModelInputs

protocol AddIncoiceFormViewModelInputs {

    var viewDidLoad: PassthroughSubject<(), Never>  { get }
    
    var viewDidAppear: PassthroughSubject<(), Never>  { get }

    var tapNavigateBack:  PassthroughSubject<(), Never> { get }

    var tapCancel: PassthroughSubject<(), Never> { get }
}


//MARK: AddIncoiceFormViewModelOutputs

enum AddIncoiceFormDestination {
    case navigateBack, cancel
}

protocol AddIncoiceFormViewModelOutputs {
    
    var title: String? { get }
    
    var navigateToDestination: PassthroughSubject<AddIncoiceFormDestination, Never> { get }
}


//MARK: AddIncoiceFormViewModelProtocol

protocol AddIncoiceFormViewModelProtocol: AnyObject {
    var inputs: AddIncoiceFormViewModelInputs { get }
    var outputs: AddIncoiceFormViewModelOutputs { get }
}
